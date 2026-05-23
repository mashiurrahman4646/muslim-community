import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:async';
import 'package:muslim_community/app_config.dart';
import 'package:muslim_community/services/tokenservice.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal() {
    print('SOCKET_DEBUG: Socket initialized');
  }

  IO.Socket? socket;
  final TokenService _tokenService = TokenService();
  bool _isConnecting = false;
  Completer<void>? _connectionCompleter;

  bool get isConnected => socket != null && socket!.connected;

  Future<void> connect() async {
    if (socket != null && socket!.connected) {
      return;
    }

    if (_isConnecting) {
      return _connectionCompleter?.future;
    }

    _isConnecting = true;
    _connectionCompleter = Completer<void>();
    
    final token = await _tokenService.getToken();
    final serverUrl = AppConfig.baseUrl.split('/api/v1')[0];

    print('SOCKET_DEBUG: Attempting to connect to socket at: $serverUrl');

    socket = IO.io(serverUrl, 
      IO.OptionBuilder()
        .setTransports(['websocket'])
        .setAuth({'token': token})
        .enableAutoConnect()
        .enableReconnection()
        .setReconnectionAttempts(10)
        .setReconnectionDelay(2000)
        .build()
    );

    socket!.onConnect((_) {
      print('SOCKET_DEBUG: Socket connected with id: ${socket!.id}');
      _isConnecting = false;
      if (_connectionCompleter != null && !_connectionCompleter!.isCompleted) {
        _connectionCompleter!.complete();
      }
    });

    socket!.onDisconnect((_) {
      print('SOCKET_DEBUG: Socket disconnected');
      _isConnecting = false;
    });

    socket!.onConnectError((data) {
      print('SOCKET_DEBUG: Socket Connect Error: $data');
      _isConnecting = false;
      if (_connectionCompleter != null && !_connectionCompleter!.isCompleted) {
        _connectionCompleter!.completeError(data);
      }
    });

    socket!.onError((data) {
      print('SOCKET_DEBUG: Socket Error: $data');
      _isConnecting = false;
    });

    return _connectionCompleter!.future;
  }

  void disconnect() {
    if (socket != null) {
      socket!.clearListeners(); // CRITICAL: Clear all listeners before disconnecting
      socket!.disconnect();
      socket = null;
      _isConnecting = false;
    }
  }

  void emit(String event, dynamic data) {
    if (isConnected) {
      socket?.emit(event, data);
    } else {
      print('WARN: Cannot emit event "$event". Socket not connected.');
    }
  }

  void on(String event, Function(dynamic) handler) {
    socket?.on(event, handler);
  }

  void off(String event) {
    socket?.off(event);
  }

  // New helper to clear specific listeners or all
  void clearListeners({List<String>? except}) {
    if (except == null || except.isEmpty) {
      socket?.clearListeners();
    } else {
      // If we want to keep some, we have to be more selective
      // but socket_io_client doesn't easily support "clear all except X"
      // So we usually manage listeners manually or just don't call clearListeners
      print('SOCKET_DEBUG: clearListeners called with exceptions. This might require manual management.');
    }
  }
}
