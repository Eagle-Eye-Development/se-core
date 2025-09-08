document.addEventListener('DOMContentLoaded', () => {
    const spawnContainer = document.getElementById('spawn-container');
    const locationsGrid = document.getElementById('locations-grid');

    // Listen for messages from the Lua client script
    window.addEventListener('message', function(event) {
        const { action, locations, lastloc } = event.data;

        if (action === 'show') {
            // Populate the UI with spawn locations
            populateLocations(locations, lastloc);
            spawnContainer.style.display = 'flex';
        } else if (action === 'hide') {
            spawnContainer.style.display = 'none';
        }
    });

    /**
     * Creates the HTML for all the location cards and adds them to the grid.
     * @param {object} locations - The list of predefined spawn locations from config.
     * @param {object} lastloc - The player's last known location.
     */
    function populateLocations(locations, lastloc) {
        locationsGrid.innerHTML = ''; // Clear any existing cards

        // First, create the card for the "Last Location"
        locationsGrid.appendChild(createLocationCard('last', lastloc, 'fa-solid fa-location-crosshairs'));

        // Then, create cards for all predefined locations from the config
        for (const id in locations) {
            locationsGrid.appendChild(createLocationCard(id, locations[id], 'fa-solid fa-map-marker-alt'));
        }
    }

    /**
     * Helper function to build a single location card element.
     * @param {string} id - The unique identifier for the location ('last', 'legion', etc.).
     * @param {object} data - The location data { label, description }.
     * @param {string} iconClass - The Font Awesome icon class.
     * @returns {HTMLElement} - The fully constructed card element.
     */
    function createLocationCard(id, data, iconClass) {
        const card = document.createElement('div');
        card.className = 'location-card';
        card.innerHTML = `
            <div class="card-title">
                <i class="${iconClass}"></i>
                <span>${data.label}</span>
            </div>
            <p class="card-description">${data.description}</p>
        `;

        // Add a click listener to send the chosen location back to Lua
        card.addEventListener('click', () => {
            postNuiCallback('selectSpawn', { id: id });
        });

        return card;
    }

    /**
     * A helper to post data back to the Lua client script.
     * @param {string} eventName - The name of the NUI callback.
     * @param {object} data - The data payload to send.
     */
    async function postNuiCallback(eventName, data = {}) {
        try {
            const resourceName = window.GetParentResourceName ? window.GetParentResourceName() : 'se-spawn';
            const response = await fetch(`https://${resourceName}/${eventName}`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json; charset=UTF-8' },
                body: JSON.stringify(data)
            });
            await response.json();
        } catch (e) {
            console.error(`Error posting NUI callback ${eventName}:`, e);
        }
    }
});
