<div class="sidebar" id="sidebar">   
    <!-- Sidebar Header -->
    <div class="sidebar-header">
        <div class="logo"><i class="fa-solid fa-comment"></i></div>
        <div class="sidebar-actions">
            <ul>
                <li>
                    <button class="theme-toggle" id="themeToggle" title="Toggle Theme">
                        <i class="fas fa-moon"></i>
                    </button>
                </li>
                <li><i class="fas fa-circle-notch" id="Status" title="Status"></i></li>
                <li><i class="fas fa-ellipsis-v" id="SettingControl" title="Menu"></i></li>
            </ul>
        </div>
    </div>

    <!-- Search -->
    <div class="search-container">
        <div class="search-box">
            <i class="fas fa-search"></i>
            <input type="text" class="search-input" placeholder="Search or start new chat">
        </div>
    </div>

    <!-- Chat List -->
    <div class="chat-list" id="chatList">
        <div class="chat-item" onclick="openChat('John Doe')">
            <div class="chat-avatar">JD</div>
            <div class="chat-info">
                <div class="chat-name">John Doe</div>
                <div class="chat-preview"><div class="last-message">Hey! How are you doing? 😊</div></div>
            </div>
        </div>
        <div class="chat-item" onclick="openChat('Sarah Wilson')">
            <div class="chat-avatar">SW</div>
            <div class="chat-info">
                <div class="chat-name">Sarah Wilson</div>
                <div class="chat-preview"><div class="last-message">Thanks for the help earlier!</div></div>
            </div>
        </div>
        <div class="chat-item" onclick="openChat('Jodan')">
            <div class="chat-avatar">JD</div>
            <div class="chat-info">
                <div class="chat-name">Jodan</div>
                <div class="chat-preview"><div class="last-message">Thanks for the help earlier!</div></div>
            </div>
        </div>
        <div class="chat-item" onclick="openChat('Sara Ali')">
            <div class="chat-avatar">SA</div>
            <div class="chat-info">
                <div class="chat-name">Sara Ali</div>
                <div class="chat-preview"><div class="last-message">Thanks for the help earlier!</div></div>
            </div>
        </div>
        <div class="chat-item" onclick="openChat('Team Group')">
            <div class="chat-avatar">TG</div>
            <div class="chat-info">
                <div class="chat-name">Team Group</div>
                <div class="chat-preview"><div class="last-message">Mike: Let's schedule the meeting</div></div>
            </div>
        </div>
        <div class="chat-item" onclick="openChat('Alex Johnson')">
            <div class="chat-avatar">AJ</div>
            <div class="chat-info">
                <div class="chat-name">Alex Johnson</div>
                <div class="chat-preview"><div class="last-message">Perfect! See you tomorrow 👍</div></div>
            </div>
        </div>
        <div class="chat-item" onclick="openChat('Emma Davis')">
            <div class="chat-avatar">ED</div>
            <div class="chat-info">
                <div class="chat-name">Emma Davis</div>
                <div class="chat-preview"><div class="last-message">Can you send me the documents?</div></div>
            </div>
        </div>
        <div class="chat-item" onclick="openChat('Family Group')">
            <div class="chat-avatar">FG</div>
            <div class="chat-info">
                <div class="chat-name">Family Group</div>
                <div class="chat-preview"><div class="last-message">Mom: Don't forget dinner on Sunday!</div></div>
            </div>
        </div>
        <div class="chat-item" onclick="openChat('Mike Chen')">
            <div class="chat-avatar">MC</div>
            <div class="chat-info">
                <div class="chat-name">Mike Chen</div>
                <div class="chat-preview"><div class="last-message">Great work on the presentation!</div></div>
            </div>
        </div>
        <div class="chat-item" onclick="openChat('Lisa Park')">
            <div class="chat-avatar">LP</div>
            <div class="chat-info">
                <div class="chat-name">Lisa Park</div>
                <div class="chat-preview"><div class="last-message">Let's catch up soon! 🎨</div></div>
            </div>
        </div>
    </div>
</div>

<div id="createRoomModal" class="modal" style="display: none; position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%); background: white; padding: 20px; box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2); border-radius: 8px; z-index: 1000;">
    <h3>Create Chat Room</h3>
    <input type="text" id="roomName" placeholder="Enter room name" style="width: 100%; padding: 10px; margin: 10px 0; border: 1px solid #ccc; border-radius: 4px;">
    <button id="createRoomSubmit" style="padding: 10px 20px; background: #007bff; color: white; border: none; border-radius: 4px; cursor: pointer;">Create</button>
    <button id="closeModal" style="padding: 10px 20px; background: #ccc; color: black; border: none; border-radius: 4px; cursor: pointer; margin-left: 10px;">Cancel</button>
</div>

<script>
    // Function to toggle between light and dark modes
    function toggleTheme() {
        const body = document.body;
        const themeIcon = document.getElementById('theme-icon');

        // Toggle the class on the body
        if (body.classList.contains('light-mode')) {
            body.classList.remove('light-mode');
            body.classList.add('dark-mode');
            themeIcon.classList.remove('fa-moon');
            themeIcon.classList.add('fa-sun');
        } else {
            body.classList.remove('dark-mode');
            body.classList.add('light-mode');
            themeIcon.classList.remove('fa-sun');
            themeIcon.classList.add('fa-moon');
        }
    }

    // Theme toggle logic
    const themeToggle = document.getElementById('themeToggle');
    const body = document.body;

    themeToggle.addEventListener('click', toggleTheme);

    // Add the theme toggle icon
    const themeIcon = document.getElementById('theme-icon');
    themeIcon.classList.add('fa-moon');
    themeIcon.style.cursor = 'pointer';
</script>