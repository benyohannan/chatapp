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

    <div class="session-debug" style="padding: 8px 12px; font-size: 12px; color: var(--text-secondary); border-bottom: 1px solid var(--border-color);">
        <div><strong>User:</strong> <%= (session.getAttribute("username") instanceof backend.models.User) ? ((backend.models.User) session.getAttribute("username")).getUsername() : (session.getAttribute("username") != null ? session.getAttribute("username").toString() : "") %></div>
        <div><strong>Session:</strong> <%= session.getId() %></div>
    </div>

    <!-- Search -->
    <div class="search-container">
        <div class="search-box">
            <i class="fas fa-search"></i>
            <input type="text" class="search-input" id="chatUserSearch" placeholder="Search or start new chat">
        </div>
        <div id="userSuggestions" class="user-suggestions" style="display:none;"></div>
    </div>

    <!-- Chat List -->
    <div class="chat-list" id="chatList">
        <!-- Dynamic content will be loaded here -->
        <div class="loading-message">Loading chats...</div>
    </div>

    <script>
        const loggedInUsername = '<%= (session.getAttribute("username") instanceof backend.models.User) ? ((backend.models.User) session.getAttribute("username")).getUsername() : (session.getAttribute("username") != null ? session.getAttribute("username").toString() : "") %>';
        const currentSessionId = '<%= session.getId() %>';
        window.loggedInUsername = loggedInUsername;
        window.currentSessionId = currentSessionId;
        if (loggedInUsername) {
            sessionStorage.setItem('username', loggedInUsername);
            localStorage.setItem('username', loggedInUsername);
        }

        document.addEventListener("DOMContentLoaded", function() {
            fetchRecentChats();
            initUserSearch();
        });

        function fetchRecentChats() {
            const username = loggedInUsername;

            if (!username) {
                console.error("Username not found in session");
                return;
            }

            fetch('/chatapp/get-recent-chats?username=' + encodeURIComponent(username))
                .then(response => response.json())
                .then(data => {
                    const chatList = document.getElementById("chatList");
                    chatList.innerHTML = "";

                    if (data.length === 0) {
                        chatList.innerHTML = '<div class="no-chats">Tap to chat</div>';
                    } else {
                        data.forEach(chat => {
                            const chatItem = document.createElement("div");
                            chatItem.className = "chat-item";
                            const chatName = (chat.name && chat.name.trim()) ? chat.name.trim() : "Unknown";
                            const avatar = chatName.charAt(0).toUpperCase();
                            const lastMessage = chat.lastMessage || "No messages yet";
                            const isGroupRoom = chat.isGroupRoom || false;

                            // Click handler - open group room or user chat
                            chatItem.onclick = () => {
                                if (isGroupRoom) {
                                    showGroupChatModal();
                                    // Find and click the room to open it
                                    setTimeout(() => {
                                        const roomItems = document.querySelectorAll('#groupChatContainer [data-room-name]');
                                        roomItems.forEach(item => {
                                            if (item.getAttribute('data-room-name') === chatName) {
                                                item.click();
                                            }
                                        });
                                    }, 100);
                                } else {
                                    openChat(chatName);
                                }
                            };

                            chatItem.innerHTML =
                                '<div class="chat-avatar">' + avatar + '</div>' +
                                '<div class="chat-info">' +
                                    '<div class="chat-name">' + (isGroupRoom ? '🏠 ' : '') + chatName + '</div>' +
                                    '<div class="chat-preview">' +
                                        '<div class="last-message">' + lastMessage + '</div>' +
                                    '</div>' +
                                '</div>';
                            chatList.appendChild(chatItem);
                        });
                    }
                })
                .catch(error => console.error("Error fetching recent chats:", error));
        }

        function initUserSearch() {
            const searchInput = document.getElementById("chatUserSearch");
            const suggestionsBox = document.getElementById("userSuggestions");
            let debounceTimer = null;

            if (!searchInput || !suggestionsBox) {
                return;
            }

            searchInput.addEventListener("input", function() {
                const query = searchInput.value.trim();

                clearTimeout(debounceTimer);

                if (!query) {
                    hideSuggestions();
                    return;
                }

                debounceTimer = setTimeout(function() {
                    fetch('/chatapp/search-users?query=' + encodeURIComponent(query) + '&currentUser=' + encodeURIComponent(loggedInUsername))
                        .then(response => response.json())
                        .then(users => renderSuggestions(users))
                        .catch(error => {
                            console.error("Error fetching user suggestions:", error);
                            hideSuggestions();
                        });
                }, 180);
            });

            document.addEventListener("click", function(event) {
                if (!suggestionsBox.contains(event.target) && event.target !== searchInput) {
                    hideSuggestions();
                }
            });

            function renderSuggestions(users) {
                if (!Array.isArray(users) || users.length === 0) {
                    suggestionsBox.innerHTML = '<div class="suggestion-empty">No users found</div>';
                    suggestionsBox.style.display = "block";
                    return;
                }

                suggestionsBox.innerHTML = "";

                users.forEach(function(user) {
                    const username = user && user.username ? user.username : "";
                    if (!username) {
                        return;
                    }

                    const item = document.createElement("div");
                    item.className = "suggestion-item";
                    item.textContent = username;
                    item.addEventListener("click", function() {
                        searchInput.value = "";
                        hideSuggestions();
                        openChat(username);
                    });
                    suggestionsBox.appendChild(item);
                });

                suggestionsBox.style.display = "block";
            }

            function hideSuggestions() {
                suggestionsBox.style.display = "none";
                suggestionsBox.innerHTML = "";
            }
        }
    </script>
</div>