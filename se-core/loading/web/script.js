document.addEventListener('DOMContentLoaded', () => {
    // --- ELEMENT SELECTORS ---
    const videoIframe = document.getElementById('video-iframe');
    const mainLogo = document.getElementById('main-logo');
    const muteText = document.getElementById('mute-text');
    const songNameElement = document.getElementById('song-name');
    const audioPlayer = document.getElementById('audio-player');
    const staffListContainer = document.getElementById('staff-list');
    const socialsContainer = document.getElementById('socials-container');
    const updatesBox = document.getElementById('updates-box');
    const infoBox = document.getElementById('info-box');
    const shadedText = document.querySelector('.shaded-text');
    const namePlaceholder = document.querySelector('#namePlaceholder > span');
    const welcomeMessage = document.getElementById('welcome-message');

    // --- POPULATE FROM CONFIG ---
    videoIframe.src = `https://www.youtube.com/embed/${Config.youtubeVideoId}?controls=0&showinfo=0&rel=0&autoplay=1&loop=1&playlist=${Config.youtubeVideoId}&mute=1`;
    mainLogo.src = Config.serverLogo;

    updatesBox.innerHTML = `
        <div class="heading-container">
            <div class="heading-textbox">UPDATES / NEWS</div>
            <div class="date">LAST UPDATED: ${Config.updatesBox.lastUpdated}</div>
        </div>
        <p>${Config.updatesBox.content}</p>`;
    
    infoBox.innerHTML = `
        <div class="heading-textbox">${Config.informationBox.title}</div>
        <p>${Config.informationBox.content}</p>`;

    Config.staff.forEach(staff => {
        staffListContainer.innerHTML += `
            <div class="person">
                <img src="${staff.avatar}">
                <span class="menu-text">${staff.name}<br>
                   <div class="role role-${staff.role}">${staff.role}</div>
                </span>
            </div>`;
    });

    Config.socials.forEach(social => {
        socialsContainer.innerHTML += `
            <a href="${social.url}" target="_blank" class="social-link">
                <img src="${social.image}" alt="${social.name}">
            </a>`;
    });

    // --- MUSIC PLAYER ---
    let currentSongIndex = 0;
    audioPlayer.volume = Config.initialVolume;

    function playSong() {
        if (!Config.music || Config.music.length === 0) return;
        audioPlayer.src = Config.music[currentSongIndex].file;
        songNameElement.textContent = Config.music[currentSongIndex].name;
        audioPlayer.play();
        muteText.textContent = "MUTE";
    }

    window.addEventListener('keyup', function(e) {
        if (e.key === 'ArrowUp') {
            audioPlayer.volume = Math.min(audioPlayer.volume + 0.05, 1);
        } else if (e.key === 'ArrowDown') {
            audioPlayer.volume = Math.max(audioPlayer.volume - 0.05, 0);
        } else if (e.key === 'ArrowLeft') {
            currentSongIndex = (currentSongIndex - 1 + Config.music.length) % Config.music.length;
            playSong();
        } else if (e.key === 'ArrowRight') {
            currentSongIndex = (currentSongIndex + 1) % Config.music.length;
            playSong();
        } else if (e.key === ' ') { // Spacebar
            if (audioPlayer.paused) {
                audioPlayer.play();
                muteText.textContent = "MUTE";
            } else {
                audioPlayer.pause();
                muteText.textContent = "UNMUTE";
            }
        }
    });
    
    // --- SHADED TEXT CYCLER ---
    const loadingTexts = ["JOINING SERVER", "PREPARING ASSETS", "ESTABLISHING CONNECTION"];
    let currentTextIndex = 0;
    setInterval(() => {
        currentTextIndex = (currentTextIndex + 1) % loadingTexts.length;
        shadedText.textContent = loadingTexts[currentTextIndex];
    }, 4000);

    // --- HANDOVER DATA (Player Name & Welcome Message) ---
    window.addEventListener('message', (event) => {
        if (event.data.type === 'nuiHandover') {
            namePlaceholder.textContent = event.data.name;
            const randomIndex = Math.floor(Math.random() * Config.welcomeMessages.length);
            welcomeMessage.textContent = Config.welcomeMessages[randomIndex];
        }
    });

    // Start first song
    playSong();
});

