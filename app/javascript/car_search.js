document.addEventListener('DOMContentLoaded', function() {
  const makeSelect = document.getElementById('car-make');
  const modelSelect = document.getElementById('car-model');

  makeSelect.addEventListener('change', function() {
    const makeName = makeSelect.value; // Get the selected make's name, not the id

    if (makeName) {
      // Make the Ajax call to fetch the models, passing make name instead of make ID
      fetch(`/car_parts/fetch_models?make=${makeName}`, {
        method: 'GET',
        headers: {
          'Accept': 'application/json'
        }
      })
      .then(response => response.json())
      .then(models => {
        modelSelect.innerHTML = ''; // Clear the current options

        if (models.length > 0) {
          models.forEach(model => {
            const option = document.createElement('option');
            option.value = model[0]; // model id
            option.textContent = model[0]; // model name
            modelSelect.appendChild(option);
          });
        } else {
          modelSelect.innerHTML = '<option value="">No models available</option>';
        }
      })
      .catch(error => {
        console.error('Error fetching models:', error);
        modelSelect.innerHTML = '<option value="">Failed to load models</option>';
      });
    } else {
      modelSelect.innerHTML = '<option value="">Select a Make First</option>';
    }
  });
});

