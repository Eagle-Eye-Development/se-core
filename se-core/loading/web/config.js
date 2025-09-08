const Config = {
    // --- SERVER DETAILS ---
    serverLogo: 'assets/logo.png', // Your server logo path
    youtubeVideoId: 'o9tVz3JbjEs', // The ID of the YouTube video for the background (e.g., o9tVz3JbjEs from https://www.youtube.com/watch?v=o9tVz3JbjEs)

    // --- MUSIC ---
    initialVolume: 0.2, // Initial music volume (0.0 to 1.0)
    music: [
        { name: "Asketa & Natan Chaim - More [NCS Release]", file: "assets/song1.mp3" },
        { name: "Akacia - Electric [NCS Release]", file: "assets/song2.mp3" },
        { name: "Wiguez & Vizzen - Running Wild [NCS Release]", file: "assets/song3.mp3" },
    ],

    // --- WELCOME MESSAGES ---
    // A random message will be chosen from this list to display next to the player's name.
    welcomeMessages: [
        'Begin your exciting new adventure.',
        'Discover the wonders of your new city.',
        'Open the door to a brand-new chapter.',
        'Step into a world of new possibilities.',
        'Embrace your fresh beginning.',
    ],

    // --- SOCIAL MEDIA LINKS ---
    // Add or remove links as needed.
    socials: [
        { name: 'Discord', image: 'assets/Discord.png', url: 'https://discord.gg/yourinvite' },
        { name: 'Tiktok', image: 'assets/Tiktok.png', url: 'https://www.tiktok.com/@yourprofile' },
        { name: 'Website', image: 'assets/Site.png', url: 'https://yourwebsite.com' },
    ],

    // --- STAFF TEAM ---
    // Add or remove staff members. Role styles are defined in style.css.
    staff: [
        { name: 'SelfishEagle', role: 'Owner', avatar: 'assets/person1.png' },
        { name: 'SelfishEagle', role: 'Manager', avatar: 'assets/person2.png' },
        { name: 'SelfishEagle', role: 'Developer', avatar: 'assets/person3.png' },
        { name: 'SelfishEagle', role: 'Admin', avatar: 'assets/person4.png' },
    ],
    
    // --- TEXT BOXES ---
    // Use HTML tags like <br> for line breaks and <span class="blue-text"> for highlights.
    updatesBox: {
        lastUpdated: "12:00 2025-09-07",
        content: `
            Welcome to our new server! <span class="blue-text">v1.0 is now live!</span>
            <br><br>
            We've added a ton of new features, including a custom vehicle fleet, new jobs, and much more.
            Make sure to join our Discord for the full patch notes and to stay up-to-date with the community.
        `
    },

    informationBox: {
        title: "BASIC SERVER INFORMATION",
        content: `
            This server is a serious roleplay server. Please ensure you have read all the rules
            before you begin your story.
            <br><br>
            If you need any help, please open a ticket in our <span class="blue-text">Discord server</span>
            and a member of the staff team will be happy to assist you.
        `
    }
};

