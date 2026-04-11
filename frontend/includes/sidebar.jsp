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
                <li>
                    <i class="fas fa-plus" id="groupChatBtn" title="Create Group" onclick="showGroupChatModal()"></i>
                </li>
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