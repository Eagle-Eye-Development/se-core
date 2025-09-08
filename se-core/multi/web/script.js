document.addEventListener('DOMContentLoaded', () => {
    // --- MULTICHARACTER ELEMENTS ---
    const mainContainer = document.getElementById('main-container');
    const charSelectContainer = document.querySelector('.character-select-container');
    const charCreateContainer = document.querySelector('.character-create-container');
    const charList = document.getElementById('character-list');
    const createNewBtn = document.getElementById('create-new-btn');
    const cancelCreateBtn = document.getElementById('cancel-create-btn');
    const creationForm = document.getElementById('creation-form');

    // --- SPAWN SELECTOR ELEMENTS ---
    const spawnContainer = document.getElementById('spawn-container');
    const locationsGrid = document.getElementById('locations-grid');

    // --- NUI MESSAGE LISTENER ---
    window.addEventListener('message', function(event) {
        const data = event.data;

        switch (data.action) {
            // Multicharacter actions
            case 'show':
                spawnContainer.style.display = 'none'; // Ensure spawn is hidden
                mainContainer.style.display = 'flex';
                renderCharacterList(data.characters);
                break;
            case 'hide':
                mainContainer.style.display = 'none';
                break;
            
            // Spawn selector actions
            case 'showSpawn':
                mainContainer.style.display = 'none'; // Ensure multichar is hidden
                populateLocations(data.locations, data.lastloc);
                spawnContainer.style.display = 'flex';
                break;
            case 'hideSpawn':
                spawnContainer.style.display = 'none';
                break;
        }
    });

    // --- MULTICHARACTER FUNCTIONS ---
    function renderCharacterList(characters) {
        charList.innerHTML = '';
        if (characters && characters.length > 0) {
            characters.forEach(char => {
                const metadata = JSON.parse(char.metadata || '{}');
                const charInfo = metadata.charinfo || {};
                const money = JSON.parse(char.money || '{}');
                const characterName = (charInfo.firstname && charInfo.lastname) ? `${charInfo.firstname} ${charInfo.lastname}` : char.name;

                const card = document.createElement('div');
                card.className = 'character-card';
                card.innerHTML = `
                    <h2 class="character-name">${characterName}</h2>
                    <div class="character-info">
                        <p>Cash: $${money.cash || 0}</p>
                        <p>DOB: ${charInfo.dob || 'N/A'}</p>
                    </div>
                    <button class="delete-char-btn" data-citizenid="${char.citizenid}">Delete</button>
                `;
                card.addEventListener('click', (e) => {
                    if (e.target.classList.contains('delete-char-btn')) return;
                    postNuiCallback('selectCharacter', { citizenid: char.citizenid });
                });
                card.querySelector('.delete-char-btn').addEventListener('click', (e) => {
                    e.stopPropagation();
                    postNuiCallback('deleteCharacter', { citizenid: char.citizenid });
                });
                charList.appendChild(card);
            });
        } else {
            charList.innerHTML = '<p style="color: #fff;">You have no characters. Create one!</p>';
        }
    }

    function showCreationMenu() {
        charSelectContainer.style.display = 'none';
        charCreateContainer.style.display = 'block';
    }

    function showSelectionMenu() {
        charCreateContainer.style.display = 'none';
        charSelectContainer.style.display = 'flex';
        creationForm.reset();
    }

    createNewBtn.addEventListener('click', showCreationMenu);
    cancelCreateBtn.addEventListener('click', showSelectionMenu);

    creationForm.addEventListener('submit', function(e) {
        e.preventDefault();
        const characterData = {
            firstname: document.getElementById('firstname').value,
            lastname: document.getElementById('lastname').value,
            dob: document.getElementById('dob').value,
            gender: document.getElementById('gender').value,
        };
        postNuiCallback('createCharacter', characterData);
    });

    // --- SPAWN SELECTOR FUNCTIONS ---
    function populateLocations(locations, lastloc) {
        locationsGrid.innerHTML = '';
        locationsGrid.appendChild(createLocationCard('last', lastloc, 'fa-solid fa-location-crosshairs'));
        for (const id in locations) {
            locationsGrid.appendChild(createLocationCard(id, locations[id], 'fa-solid fa-map-marker-alt'));
        }
    }

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
        card.addEventListener('click', () => {
            postNuiCallback('selectSpawn', { id: id });
        });
        return card;
    }

    // --- NUI HELPER ---
    async function postNuiCallback(eventName, data = {}) {
        try {
            const resourceName = window.GetParentResourceName ? window.GetParentResourceName() : 'se-core';
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

    postNuiCallback('nuiReady');
});
