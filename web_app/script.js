const baseUrl = "http://10.10.7.47:5002/api/v1";
let currentStep = 1;
const formData = {
    role: "",
    name: "",
    email: "",
    password: "",
    revertDate: "",
    dateOfBirth: "",
    verificationImage: null,
    verificationVideo: null
};

// Initialize
document.addEventListener('DOMContentLoaded', () => {
    updateProgress();
    setupFileUploads();
});

function goToStep(step) {
    // Hide all steps
    document.querySelectorAll('.form-step').forEach(el => el.classList.remove('active'));
    
    // Set current step data
    if (step === 2) {
        const role = document.getElementById('roleSelect').value;
        if (!role) {
            alert("Please select a role first!");
            return;
        }
        formData.role = role;
        document.getElementById('roleDisplay').value = role;
    }

    // Show step
    document.getElementById(`step${step}`).classList.add('active');
    currentStep = step;
    updateProgress();
}

function updateProgress() {
    const bar = document.getElementById('progressBar');
    const dots = document.querySelectorAll('.step-dot');
    const percent = ((currentStep - 1) / (dots.length - 1)) * 100;
    
    bar.style.width = `${percent}%`;
    
    dots.forEach((dot, idx) => {
        if (idx + 1 <= currentStep) {
            dot.classList.add('active');
        } else {
            dot.classList.remove('active');
        }
    });
}

function validateStep2() {
    const name = document.getElementById('name').value;
    const email = document.getElementById('email').value;
    const password = document.getElementById('password').value;
    const revertDate = document.getElementById('revertDate').value;
    const dob = document.getElementById('dateOfBirth').value;

    if (!name || !email || !password || !revertDate || !dob) {
        alert("Please fill in all fields.");
        return;
    }

    // Check age (16+)
    const birthDate = new Date(dob);
    const today = new Date();
    let age = today.getFullYear() - birthDate.getFullYear();
    const m = today.getMonth() - birthDate.getMonth();
    if (m < 0 || (m === 0 && today.getDate() < birthDate.getDate())) {
        age--;
    }

    if (age < 16) {
        alert("You must be at least 16 years old to register.");
        return;
    }

    // Check password format (basic check)
    if (password.length < 8) {
        alert("Password must be at least 8 characters long.");
        return;
    }

    formData.name = name;
    formData.email = email;
    formData.password = password;
    formData.revertDate = new Date(revertDate).toISOString();
    formData.dateOfBirth = new Date(dob).toISOString();

    goToStep(3);
}

function setupFileUploads() {
    const imgBox = document.getElementById('imageUploadBox');
    const vidBox = document.getElementById('videoUploadBox');
    const imgInput = document.getElementById('verificationImage');
    const vidInput = document.getElementById('verificationVideo');

    imgBox.onclick = () => imgInput.click();
    vidBox.onclick = () => vidInput.click();

    imgInput.onchange = (e) => {
        const file = e.target.files[0];
        if (file) {
            if (file.size > 100 * 1024 * 1024) {
                alert("File size exceeds 100MB");
                return;
            }
            formData.verificationImage = file;
            document.getElementById('imgName').innerText = file.name;
            imgBox.classList.add('has-file');
        }
    };

    vidInput.onchange = (e) => {
        const file = e.target.files[0];
        if (file) {
            if (file.size > 100 * 1024 * 1024) {
                alert("File size exceeds 100MB");
                return;
            }
            formData.verificationVideo = file;
            document.getElementById('vidName').innerText = file.name;
            vidBox.classList.add('has-file');
        }
    };
}

async function submitRegistration() {
    if (!formData.verificationImage || !formData.verificationVideo) {
        alert("Please upload both image and video for verification.");
        return;
    }

    const btn = document.getElementById('submitBtn');
    const loader = document.getElementById('submitLoader');
    const btnText = btn.querySelector('.btn-text');

    btn.disabled = true;
    loader.style.display = 'block';
    btnText.style.display = 'none';

    const multipartData = new FormData();
    multipartData.append('name', formData.name);
    multipartData.append('email', formData.email);
    multipartData.append('password', formData.password);
    multipartData.append('role', formData.role);
    multipartData.append('revertDate', formData.revertDate);
    multipartData.append('dateOfBirth', formData.dateOfBirth);
    multipartData.append('verificationImage', formData.verificationImage);
    multipartData.append('verificationVideo', formData.verificationVideo);

    try {
        const response = await fetch(`${baseUrl}/users`, {
            method: 'POST',
            body: multipartData
        });

        const result = await response.json();

        if (response.status === 201 || result.success) {
            showSuccess(result.message);
        } else {
            alert(`Registration failed: ${result.message || 'Unknown error'}`);
            resetButton();
        }
    } catch (error) {
        console.error("API Error:", error);
        alert("Something went wrong with the API connection.");
        resetButton();
    }
}

function showSuccess(msg) {
    document.getElementById('successMsg').innerText = msg;
    document.getElementById('successModal').classList.add('active');
}

function resetButton() {
    const btn = document.getElementById('submitBtn');
    const loader = document.getElementById('submitLoader');
    const btnText = btn.querySelector('.btn-text');
    btn.disabled = false;
    loader.style.display = 'none';
    btnText.style.display = 'block';
}

function redirectToOTP() {
    // Redirect to your actual OTP page or a mock one
    alert("Redirecting to OTP Verification...");
    window.location.href = "#otp-page"; // Replace with actual URL
}
