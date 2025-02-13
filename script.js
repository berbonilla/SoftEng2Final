var loginflag = false;

window.onload = function () {
    if (loginflag == false){
        setTimeout(function () {
            document.getElementById("loginForm").submit();
        }, 5000);
        setInterval(getStatus, 5000);
        getStatus();
    }
};

function getStatus() {
    fetch('read_serial.php')  // Fetch the output from the PHP endpoint
        .then(response => response.text())  
        .then(data => {
            const statusDiv = document.getElementById('status');
            statusDiv.innerHTML = data;

            // Show the div with the updated status
            statusDiv.style.display = 'block';

            if (data.includes('Access Verified!')) {
                statusDiv.classList.remove('invalid', 'waiting');
                statusDiv.classList.add('valid');

                // Redirect to landing.html after 2 seconds
                setTimeout(() => {
                    window.location.href = 'landing.html';
                }, 2000);
            } else if (data.includes('Account Not Found!')) {
                statusDiv.classList.remove('valid', 'waiting');
                statusDiv.classList.add('invalid');    
            } else {
                statusDiv.classList.remove('valid', 'invalid');
                statusDiv.classList.style
                statusDiv.style.borderRadius = "0px";
                statusDiv.style.boxShadow = "0 0px 0px rgba(0, 0, 0, 0)";
                statusDiv.style.position='absolute';
                statusDiv.style.left='40%';
                statusDiv.style.top='70%';

            }

            // Hide the div after 2 seconds
            setTimeout(() => {
                statusDiv.style.display = 'none';
            }, 2000);
        })
        .catch(error => {
            console.error('Error:', error);
            const statusDiv = document.getElementById('status');
            statusDiv.innerHTML = 'Error fetching status.';
            statusDiv.style.display = 'block';

            // Hide the div after 2 seconds
            setTimeout(() => {
                statusDiv.style.display = 'none';
            }, 2000);
        });
}


const statusDiv = document.getElementById('status');

// Show the status div (fade-in happens automatically)
setTimeout(() => {
    statusDiv.classList.remove('fade-out');
}, 500);

// Hide the status div after 3 seconds with fade-out
setTimeout(() => {
    statusDiv.classList.add('fade-out');
}, 3000);

// Remove the element from DOM after fade-out completes
statusDiv.addEventListener('animationend', (event) => {
    if (event.animationName === 'fadeOut') {
        statusDiv.style.display = 'none';
    }
});