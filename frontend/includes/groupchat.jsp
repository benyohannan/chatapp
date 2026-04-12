<%
    String groupUsername = "";
    Object groupSessionUsername = session.getAttribute("username");
    if (groupSessionUsername instanceof backend.models.User) {
        groupUsername = ((backend.models.User) groupSessionUsername).getUsername();
    } else if (groupSessionUsername != null) {
        groupUsername = groupSessionUsername.toString();
    }
    String groupUsernameJs = groupUsername.replace("\\", "\\\\")
            .replace("\"", "\\\"")
            .replace("\n", "\\n")
            .replace("\r", "\\r");
%>

<div class="group-chat-container" id="groupChatContainer" style="display:none;">
    <div class="group-room-panel">
        <div class="group-panel-header">
            <div>
                <div class="group-panel-kicker">Rooms</div>
                <h3>Group Chat</h3>
            </div>
            <i class="fas fa-times" onclick="hideGroupChatModal()" title="Close"></i>
        </div>

        <div class="group-panel-card">
            <label for="groupRoomSearchInput">Search rooms to join</label>
            <input type="text" id="groupRoomSearchInput" placeholder="Search by room name">
            <div class="group-room-results" id="groupRoomResults"></div>
        </div>

        <div class="group-panel-card">
            <label for="groupNameInput">Create room</label>
            <input type="text" id="groupNameInput" placeholder="Unique room name">

            <label for="groupMemberSearchInput">Add members</label>
            <input type="text" id="groupMemberSearchInput" placeholder="Search users by name">
            <div class="group-suggestions" id="groupMemberSuggestions"></div>

            <div class="selected-member-chips" id="selectedMemberChips"></div>

            <button class="group-primary-btn" id="createGroupBtn" type="button">Create room</button>
            <div class="group-helper-text">A room needs a unique name and at least one added member.</div>
        </div>
    </div>

    <div class="group-chat-area">
        <div class="group-chat-view">
            <div class="group-chat-header">
                <div>
                    <h3 id="groupTitle">Select or create a room</h3>
                    <div class="group-chat-meta" id="groupRoomMeta">Search rooms on the left or create a new one.</div>
                </div>
                <button class="group-secondary-btn" id="groupRefreshRoomsBtn" type="button">Refresh</button>
            </div>

            <div class="group-empty-state" id="groupEmptyState">
                <div class="group-empty-card">
                    <i class="fas fa-comments"></i>
                    <h4>No room selected</h4>
                    <p>Create a unique room or join one from search to start chatting.</p>
                </div>
            </div>

            <div class="chat-messages group-room-messages" id="groupRoomMessages" style="display:none;"></div>

            <div class="chat-input-container" id="groupChatInputBar" style="display:none;">
                <input type="text" id="groupMessageInput" placeholder="Type a message...">
                <button id="sendGroupBtn" type="button"><i class="fas fa-paper-plane"></i></button>
            </div>
        </div>
    </div>
</div>

<style>
:root {
    --groupchat-shell: linear-gradient(135deg, #0e1720 0%, #12222b 45%, #0b141a 100%);
    --groupchat-card: rgba(255, 255, 255, 0.06);
    --groupchat-line: rgba(255, 255, 255, 0.08);
    --groupchat-soft: rgba(255, 255, 255, 0.06);
    --groupchat-text: #e9edef;
    --groupchat-muted: #8696a0;
    --groupchat-accent: #25d366;
    --groupchat-accent-2: #128c7e;
    --groupchat-input: #111b21;
}

.light-mode {
    --groupchat-shell: linear-gradient(135deg, #eef3f7 0%, #dde6ee 40%, #f7f9fb 100%);
    --groupchat-card: rgba(255, 255, 255, 0.92);
    --groupchat-line: rgba(16, 24, 40, 0.08);
    --groupchat-soft: rgba(16, 24, 40, 0.05);
    --groupchat-text: #18212b;
    --groupchat-muted: #64748b;
    --groupchat-accent: #0f9d58;
    --groupchat-accent-2: #0c7a48;
    --groupchat-input: #ffffff;
}

.group-chat-container {
    display: flex;
    position: absolute;
    inset: 0 0 0 400px;
    z-index: 9999;
    background: var(--groupchat-shell);
    color: var(--groupchat-text);
    font-family: inherit;
    overflow: hidden;
}

.group-room-panel {
    width: 360px;
    min-width: 320px;
    max-width: 420px;
    padding: 18px;
    display: flex;
    flex-direction: column;
    gap: 14px;
    border-right: 1px solid var(--groupchat-line);
    background: rgba(0, 0, 0, 0.08);
    backdrop-filter: blur(18px);
    overflow-y: auto;
}

.group-panel-header,
.group-chat-header {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    gap: 12px;
}

.group-panel-header h3,
.group-chat-header h3 {
    margin: 0;
    font-size: 24px;
    font-weight: 700;
    letter-spacing: -0.4px;
}

.group-panel-kicker {
    text-transform: uppercase;
    letter-spacing: 0.14em;
    font-size: 11px;
    color: var(--groupchat-muted);
    margin-bottom: 4px;
}

.group-panel-header i {
    cursor: pointer;
    color: var(--groupchat-muted);
    font-size: 18px;
}

.group-panel-card {
    background: var(--groupchat-card);
    border: 1px solid var(--groupchat-line);
    border-radius: 18px;
    padding: 16px;
    box-shadow: 0 20px 45px rgba(0, 0, 0, 0.12);
    display: flex;
    flex-direction: column;
    gap: 10px;
}

.group-panel-card label {
    font-size: 12px;
    text-transform: uppercase;
    letter-spacing: 0.1em;
    color: var(--groupchat-muted);
}

.group-panel-card input,
.group-chat-header input,
.chat-input-container input {
    width: 100%;
    border: 1px solid var(--groupchat-line);
    border-radius: 14px;
    padding: 12px 14px;
    font-size: 14px;
    background: var(--groupchat-input);
    color: var(--groupchat-text);
    outline: none;
}

.group-panel-card input:focus,
.chat-input-container input:focus {
    border-color: rgba(37, 211, 102, 0.65);
    box-shadow: 0 0 0 3px rgba(37, 211, 102, 0.12);
}

.group-room-results,
.group-suggestions {
    display: flex;
    flex-direction: column;
    gap: 8px;
    max-height: 220px;
    overflow-y: auto;
}

.group-room-result,
.group-suggestion-item {
    background: rgba(255, 255, 255, 0.04);
    border: 1px solid var(--groupchat-line);
    border-radius: 14px;
    padding: 12px 14px;
    cursor: pointer;
    transition: transform 0.18s ease, border-color 0.18s ease, background 0.18s ease;
}

.group-room-result:hover,
.group-suggestion-item:hover {
    transform: translateY(-1px);
    border-color: rgba(37, 211, 102, 0.5);
    background: rgba(37, 211, 102, 0.08);
}

.group-room-result.active {
    border-color: rgba(37, 211, 102, 0.72);
    background: rgba(37, 211, 102, 0.12);
}

.group-room-result-title,
.group-suggestion-name {
    font-weight: 600;
    font-size: 14px;
}

.group-room-result-meta,
.group-chat-meta,
.group-helper-text,
.group-suggestion-meta {
    font-size: 12px;
    color: var(--groupchat-muted);
}

.selected-member-chips {
    display: flex;
    flex-wrap: wrap;
    gap: 8px;
}

.selected-member-chip {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    border-radius: 999px;
    padding: 8px 12px;
    background: rgba(37, 211, 102, 0.12);
    border: 1px solid rgba(37, 211, 102, 0.28);
    font-size: 13px;
}

.selected-member-chip button {
    border: none;
    background: transparent;
    color: inherit;
    cursor: pointer;
    padding: 0;
}

.group-primary-btn,
.group-secondary-btn {
    border: none;
    border-radius: 14px;
    padding: 12px 16px;
    font-weight: 600;
    cursor: pointer;
    transition: transform 0.18s ease, opacity 0.18s ease;
}

.group-primary-btn {
    background: linear-gradient(135deg, var(--groupchat-accent) 0%, var(--groupchat-accent-2) 100%);
    color: #fff;
}

.group-secondary-btn {
    background: rgba(255, 255, 255, 0.06);
    color: var(--groupchat-text);
    border: 1px solid var(--groupchat-line);
}

.group-primary-btn:hover,
.group-secondary-btn:hover {
    transform: translateY(-1px);
}

.group-helper-text {
    line-height: 1.45;
}

.group-chat-area {
    flex: 1;
    display: flex;
    min-width: 0;
    min-height: 0;
}

.group-chat-view {
    flex: 1;
    display: flex;
    flex-direction: column;
    min-width: 0;
    min-height: 0;
    background: rgba(0, 0, 0, 0.08);
    backdrop-filter: blur(16px);
}

.group-chat-header {
    padding: 20px 22px;
    border-bottom: 1px solid var(--groupchat-line);
    background: rgba(255, 255, 255, 0.03);
    align-items: center;
}

.group-empty-state {
    flex: 1;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 24px;
}

.group-empty-card {
    max-width: 420px;
    width: 100%;
    text-align: center;
    padding: 30px;
    background: var(--groupchat-card);
    border: 1px solid var(--groupchat-line);
    border-radius: 24px;
}

.group-empty-card i {
    font-size: 42px;
    color: var(--groupchat-accent);
    margin-bottom: 12px;
}

.group-empty-card h4 {
    margin: 0 0 8px;
    font-size: 22px;
}

.group-empty-card p {
    margin: 0;
    color: var(--groupchat-muted);
    line-height: 1.5;
}

.group-room-messages {
    flex: 1;
    overflow-y: auto;
    padding: 20px;
    background: linear-gradient(180deg, rgba(255, 255, 255, 0.01), rgba(255, 255, 255, 0.03));
}

.group-message-row {
    display: flex;
    margin-bottom: 12px;
}

.group-message-row.sent {
    justify-content: flex-end;
}

.group-message-row.received {
    justify-content: flex-start;
}

.group-message-bubble {
    max-width: min(72%, 640px);
    padding: 10px 14px;
    border-radius: 18px;
    background: rgba(255, 255, 255, 0.08);
    border: 1px solid var(--groupchat-line);
    box-shadow: 0 10px 24px rgba(0, 0, 0, 0.12);
}

.group-message-row.sent .group-message-bubble {
    background: linear-gradient(135deg, var(--groupchat-accent) 0%, var(--groupchat-accent-2) 100%);
    color: #fff;
    border-color: transparent;
}

.group-message-sender {
    display: block;
    font-size: 11px;
    text-transform: uppercase;
    letter-spacing: 0.08em;
    opacity: 0.8;
    margin-bottom: 4px;
}

.group-message-text {
    font-size: 14px;
    line-height: 1.45;
    white-space: pre-wrap;
    word-break: break-word;
}

.group-message-time {
    display: block;
    font-size: 11px;
    opacity: 0.72;
    margin-top: 6px;
    text-align: right;
}

.chat-input-container {
    display: flex;
    gap: 10px;
    align-items: center;
    padding: 16px 20px;
    border-top: 1px solid var(--groupchat-line);
    background: rgba(0, 0, 0, 0.06);
}

.chat-input-container button {
    width: 46px;
    height: 46px;
    border: none;
    border-radius: 50%;
    background: linear-gradient(135deg, var(--groupchat-accent) 0%, var(--groupchat-accent-2) 100%);
    color: white;
    cursor: pointer;
    flex-shrink: 0;
}

@media (max-width: 1024px) {
    .group-chat-container {
        inset: 0;
        flex-direction: column;
    }

    .group-room-panel {
        width: 100%;
        max-width: none;
        border-right: none;
        border-bottom: 1px solid var(--groupchat-line);
    }
}

@media (max-width: 768px) {
    .group-chat-view {
        height: 100%;
        display: flex;
        flex-direction: column;
    }

    .group-room-messages {
        flex: 1;
        min-height: 0;
        overflow-y: auto;
        -webkit-overflow-scrolling: touch;
        padding: 12px;
    }

    .group-message-bubble {
        max-width: min(85%, 480px);
    }

    .chat-input-container {
        padding: 12px 16px;
        flex-shrink: 0;
    }

    .group-chat-header {
        flex-shrink: 0;
    }
}
</style>

<script>
let groupChatState = {
    username: "<%= groupUsernameJs %>",
    selectedMembers: [],
    activeRoomName: null,
    activeRoomMembers: [],
    ws: null,
    pollTimer: null,
    suggestionsTimer: null,
    roomSearchTimer: null,
    currentRoomKeys: new Set(),
    sentClientMessageIds: new Set(),
    rooms: []
};

function getGroupUsername() {
    return groupChatState.username || window.loggedInUsername || localStorage.getItem('username') || '';
}

function showGroupChatModal() {
    const container = document.getElementById('groupChatContainer');
    if (!container) {
        return;
    }

    container.style.display = 'flex';
    showCreateScreen();
    refreshGroupRooms();
    renderSelectedMembers();
}

function hideGroupChatModal() {
    stopGroupRoomRealtime();
    const container = document.getElementById('groupChatContainer');
    if (container) {
        container.style.display = 'none';
    }
}

function showCreateScreen() {
    const emptyState = document.getElementById('groupEmptyState');
    const messages = document.getElementById('groupRoomMessages');
    const inputBar = document.getElementById('groupChatInputBar');
    if (emptyState) emptyState.style.display = 'flex';
    if (messages) messages.style.display = 'none';
    if (inputBar) inputBar.style.display = 'none';
}

function showChatView() {
    const emptyState = document.getElementById('groupEmptyState');
    const messages = document.getElementById('groupRoomMessages');
    const inputBar = document.getElementById('groupChatInputBar');
    if (emptyState) emptyState.style.display = 'none';
    if (messages) messages.style.display = 'block';
    if (inputBar) inputBar.style.display = 'flex';
}

function escapeHtml(value) {
    return String(value || '')
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;')
        .replace(/'/g, '&#39;');
}

function renderSelectedMembers() {
    const chips = document.getElementById('selectedMemberChips');
    if (!chips) {
        return;
    }

    chips.innerHTML = '';
    groupChatState.selectedMembers.forEach(member => {
        const chip = document.createElement('span');
        chip.className = 'selected-member-chip';
        chip.innerHTML = '<span>' + escapeHtml(member) + '</span>';

        const removeBtn = document.createElement('button');
        removeBtn.type = 'button';
        removeBtn.textContent = '×';
        removeBtn.addEventListener('click', function() {
            groupChatState.selectedMembers = groupChatState.selectedMembers.filter(value => value !== member);
            renderSelectedMembers();
        });

        chip.appendChild(removeBtn);
        chips.appendChild(chip);
    });
}

function addGroupMember(username) {
    const cleanName = (username || '').trim();
    const currentUser = getGroupUsername();
    if (!cleanName || cleanName === currentUser) {
        return;
    }

    if (!groupChatState.selectedMembers.includes(cleanName)) {
        groupChatState.selectedMembers.push(cleanName);
        renderSelectedMembers();
    }
}

function refreshGroupRooms(query) {
    const username = getGroupUsername();
    if (!username) {
        return;
    }

    const url = '/chatapp/group-rooms?username=' + encodeURIComponent(username) + (query ? '&query=' + encodeURIComponent(query) : '');
    fetch(url, { cache: 'no-store' })
        .then(response => response.json())
        .then(rooms => {
            groupChatState.rooms = Array.isArray(rooms) ? rooms : [];
            renderGroupRooms(groupChatState.rooms);
        })
        .catch(error => {
            console.error('Error loading group rooms:', error);
            renderGroupRooms([]);
        });
}

function renderGroupRooms(rooms) {
    const list = document.getElementById('groupRoomResults');
    if (!list) {
        return;
    }

    list.innerHTML = '';
    if (!rooms || rooms.length === 0) {
        const empty = document.createElement('div');
        empty.className = 'group-room-result';
        empty.innerHTML = '<div class="group-room-result-title">No rooms found</div><div class="group-room-result-meta">Create a room or search a different name.</div>';
        list.appendChild(empty);
        return;
    }

    rooms.forEach(room => {
        const item = document.createElement('div');
        item.className = 'group-room-result' + (groupChatState.activeRoomName === room.roomName ? ' active' : '');
        item.setAttribute('data-room-name', room.roomName);

        const members = Array.isArray(room.members) ? room.members : [];
        const memberSummary = members.length ? members.join(', ') : 'No members';
        const actionLabel = room.isMember ? 'Open room' : 'Join room';

        item.innerHTML =
            '<div class="group-room-result-title">' + escapeHtml(room.roomName || 'Untitled room') + '</div>' +
            '<div class="group-room-result-meta">' + escapeHtml(room.lastMessage || 'No messages yet') + '</div>' +
            '<div class="group-room-result-meta">Members: ' + escapeHtml(memberSummary) + '</div>' +
            '<div class="group-room-result-meta">' + escapeHtml(actionLabel) + '</div>';

        item.addEventListener('click', function() {
            if (room.isMember) {
                openGroupRoom(room.roomName, room.members || []);
            } else {
                joinGroupRoom(room.roomName);
            }
        });

        list.appendChild(item);
    });
}

function searchGroupRooms(value) {
    clearTimeout(groupChatState.roomSearchTimer);
    groupChatState.roomSearchTimer = setTimeout(function() {
        refreshGroupRooms(value);
    }, 180);
}

function initGroupMemberSearch() {
    const input = document.getElementById('groupMemberSearchInput');
    const suggestions = document.getElementById('groupMemberSuggestions');
    if (!input || !suggestions) {
        return;
    }

    input.addEventListener('input', function() {
        const query = input.value.trim();
        clearTimeout(groupChatState.suggestionsTimer);

        if (!query) {
            suggestions.innerHTML = '';
            return;
        }

        groupChatState.suggestionsTimer = setTimeout(function() {
            fetch('/chatapp/search-users?query=' + encodeURIComponent(query) + '&currentUser=' + encodeURIComponent(getGroupUsername()), { cache: 'no-store' })
                .then(response => response.json())
                .then(users => {
                    suggestions.innerHTML = '';
                    const list = Array.isArray(users) ? users : [];
                    if (list.length === 0) {
                        suggestions.innerHTML = '<div class="group-suggestion-item"><div class="group-suggestion-name">No users found</div></div>';
                        return;
                    }

                    list.forEach(user => {
                        const username = user && user.username ? user.username.trim() : '';
                        if (!username) {
                            return;
                        }

                        const item = document.createElement('div');
                        item.className = 'group-suggestion-item';
                        item.innerHTML = '<div class="group-suggestion-name">' + escapeHtml(username) + '</div><div class="group-suggestion-meta">Click to add to the room</div>';
                        item.addEventListener('click', function() {
                            addGroupMember(username);
                            input.value = '';
                            suggestions.innerHTML = '';
                        });
                        suggestions.appendChild(item);
                    });
                })
                .catch(error => {
                    console.error('Error searching users:', error);
                    suggestions.innerHTML = '';
                });
        }, 180);
    });
}

function clearGroupRoomState() {
    groupChatState.currentRoomKeys = new Set();
    const messages = document.getElementById('groupRoomMessages');
    if (messages) {
        messages.innerHTML = '';
    }
}

function openGroupRoom(roomName, members) {
    const cleanRoomName = (roomName || '').trim();
    if (!cleanRoomName) {
        return;
    }

    groupChatState.activeRoomName = cleanRoomName;
    groupChatState.activeRoomMembers = Array.isArray(members) ? members : [];
    document.getElementById('groupTitle').textContent = cleanRoomName;
    document.getElementById('groupRoomMeta').textContent = groupChatState.activeRoomMembers.length ? ('Members: ' + groupChatState.activeRoomMembers.join(', ')) : 'Room members loaded from server';

    showChatView();
    clearGroupRoomState();
    loadGroupRoomMessages(cleanRoomName);
    startGroupRoomRealtime(cleanRoomName);
    refreshGroupRooms(document.getElementById('groupRoomSearchInput') ? document.getElementById('groupRoomSearchInput').value.trim() : '');
}

function joinGroupRoom(roomName) {
    const username = getGroupUsername();
    const cleanRoomName = (roomName || '').trim();
    if (!username || !cleanRoomName) {
        return;
    }

    fetch('/chatapp/join-group-room', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
        },
        body: 'username=' + encodeURIComponent(username) + '&roomName=' + encodeURIComponent(cleanRoomName)
    })
        .then(response => response.json().then(body => ({ status: response.status, body: body })))
        .then(result => {
            if (result.status >= 400) {
                throw new Error(result.body && result.body.error ? result.body.error : 'Unable to join room');
            }

            openGroupRoom(result.body.roomName || cleanRoomName);
        })
        .catch(error => {
            console.error('Error joining room:', error);
            alert(error.message || 'Unable to join room');
        });
}

function createGroupRoom() {
    const username = getGroupUsername();
    const roomNameInput = document.getElementById('groupNameInput');
    const roomName = roomNameInput ? roomNameInput.value.trim() : '';

    if (!username) {
        alert('Session user not found. Please sign in again.');
        return;
    }

    if (!roomName) {
        alert('Please enter a room name.');
        return;
    }

    if (groupChatState.selectedMembers.length === 0) {
        alert('Please add at least one member.');
        return;
    }

    const members = groupChatState.selectedMembers.slice();
    fetch('/chatapp/create-group-room', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
        },
        body: 'creator=' + encodeURIComponent(username) + '&roomName=' + encodeURIComponent(roomName) + '&members=' + encodeURIComponent(members.join(','))
    })
        .then(response => response.json().then(body => ({ status: response.status, body: body })))
        .then(result => {
            if (result.status >= 400) {
                throw new Error(result.body && result.body.error ? result.body.error : 'Unable to create room');
            }

            const createdRoomName = result.body && result.body.roomName ? result.body.roomName : roomName;
            const createdMembers = [username].concat(members);

            roomNameInput.value = '';
            groupChatState.selectedMembers = [];
            renderSelectedMembers();
            const memberSearch = document.getElementById('groupMemberSearchInput');
            const suggestions = document.getElementById('groupMemberSuggestions');
            if (memberSearch) memberSearch.value = '';
            if (suggestions) suggestions.innerHTML = '';

            refreshGroupRooms();
            openGroupRoom(createdRoomName, createdMembers);
        })
        .catch(error => {
            console.error('Error creating room:', error);
            alert(error.message || 'Unable to create room');
        });
}

function startGroupRoomRealtime(roomName) {
    stopGroupRoomRealtime();

    const username = getGroupUsername();
    const protocol = window.location.protocol === 'https:' ? 'wss://' : 'ws://';
    const socketUrl = protocol + window.location.host + '/chatapp/ws/group-chat?roomName=' + encodeURIComponent(roomName) + '&username=' + encodeURIComponent(username);

    try {
        groupChatState.ws = new WebSocket(socketUrl);
    } catch (error) {
        console.error('Unable to open group websocket:', error);
        scheduleGroupRoomPolling(roomName);
        return;
    }

    groupChatState.ws.onopen = function() {
        scheduleGroupRoomPolling(roomName);
    };

    groupChatState.ws.onmessage = function(event) {
        try {
            const payload = JSON.parse(event.data);
            if (payload.type !== 'chat' || !payload.roomName || payload.roomName.toLowerCase() !== roomName.toLowerCase()) {
                return;
            }

            // Skip messages we just sent from optimistic update
            if (payload.clientMessageId && groupChatState.sentClientMessageIds.has(payload.clientMessageId)) {
                groupChatState.sentClientMessageIds.delete(payload.clientMessageId);
                console.log('Skipping duplicate message:', payload.clientMessageId);
                return;
            }

            // Also check if message already in DOM using clientMessageId or messageId
            const key = groupMessageKey(payload);
            if (key && groupChatState.currentRoomKeys.has(key)) {
                console.log('Message already in DOM:', key);
                return;
            }

            appendGroupRoomMessage(payload);
        } catch (error) {
            console.error('Invalid group websocket payload:', error);
        }
    };

    groupChatState.ws.onclose = function() {
        scheduleGroupRoomPolling(roomName);
    };

    groupChatState.ws.onerror = function() {
        scheduleGroupRoomPolling(roomName);
    };
}

function stopGroupRoomRealtime() {
    if (groupChatState.ws) {
        try {
            groupChatState.ws.close();
        } catch (error) {
            console.error('Error closing group websocket:', error);
        }
        groupChatState.ws = null;
    }

    if (groupChatState.pollTimer) {
        clearInterval(groupChatState.pollTimer);
        groupChatState.pollTimer = null;
    }
}

function scheduleGroupRoomPolling(roomName) {
    if (groupChatState.pollTimer) {
        return;
    }

    groupChatState.pollTimer = setInterval(function() {
        if (roomName && groupChatState.activeRoomName && roomName.toLowerCase() === groupChatState.activeRoomName.toLowerCase()) {
            loadGroupRoomMessages(roomName, true);
        }
    }, 3500);
}

function loadGroupRoomMessages(roomName, silent) {
    const username = getGroupUsername();
    const cleanRoomName = (roomName || '').trim();
    if (!username || !cleanRoomName) {
        return;
    }

    fetch('/chatapp/group-room-messages?roomName=' + encodeURIComponent(cleanRoomName) + '&username=' + encodeURIComponent(username), { cache: 'no-store' })
        .then(response => response.json().then(body => ({ status: response.status, body: body })))
        .then(result => {
            if (result.status >= 400) {
                throw new Error(result.body && result.body.error ? result.body.error : 'Unable to load room messages');
            }

            const messages = Array.isArray(result.body.messages) ? result.body.messages : [];
            if (!silent) {
                const container = document.getElementById('groupRoomMessages');
                if (container) {
                    container.innerHTML = '';
                }
                groupChatState.currentRoomKeys = new Set();
            }

            messages.forEach(message => appendGroupRoomMessage({
                roomName: cleanRoomName,
                sender: message.sender,
                message: message.message,
                timestamp: message.timestamp,
                messageId: message.id,
                clientMessageId: message.clientMessageId
            }));
        })
        .catch(error => {
            if (!silent) {
                console.error('Error loading group room messages:', error);
            }
        });
}

function groupMessageKey(payload) {
    if (!payload) {
        return '';
    }

    // Prioritize clientMessageId (unique per send) over messageId
    if (payload.clientMessageId) {
        return payload.clientMessageId;
    }
    
    // Fallback to messageId if clientMessageId not present
    if (payload.messageId) {
        return payload.messageId;
    }

    // Last resort: combine all fields for hash
    return [payload.roomName || '', payload.sender || '', payload.message || '', payload.timestamp || ''].join('|');
}

function appendGroupRoomMessage(payload) {
    const messages = document.getElementById('groupRoomMessages');
    if (!messages || !payload) {
        return;
    }

    const key = groupMessageKey(payload);
    if (key && groupChatState.currentRoomKeys.has(key)) {
        return;
    }
    if (key) {
        groupChatState.currentRoomKeys.add(key);
    }

    const currentUser = getGroupUsername();
    const isSent = payload.sender && payload.sender.trim() === currentUser;
    const row = document.createElement('div');
    row.className = 'group-message-row ' + (isSent ? 'sent' : 'received');

    const bubble = document.createElement('div');
    bubble.className = 'group-message-bubble';

    const sender = document.createElement('span');
    sender.className = 'group-message-sender';
    sender.textContent = isSent ? 'You' : (payload.sender || 'Unknown');

    const text = document.createElement('div');
    text.className = 'group-message-text';
    text.textContent = payload.message || '';

    const time = document.createElement('span');
    time.className = 'group-message-time';
    time.textContent = payload.timestamp || '';

    bubble.appendChild(sender);
    bubble.appendChild(text);
    bubble.appendChild(time);
    row.appendChild(bubble);
    messages.appendChild(row);
    messages.scrollTop = messages.scrollHeight;
}

function sendGroupMessage() {
    const input = document.getElementById('groupMessageInput');
    if (!input || !groupChatState.activeRoomName) {
        return;
    }

    const message = input.value.trim();
    if (!message) {
        return;
    }

    const username = getGroupUsername();
    const clientMessageId = 'grp_' + Date.now() + '_' + Math.random().toString(36).slice(2, 9);
    const roomName = groupChatState.activeRoomName;

    input.value = '';
    groupChatState.sentClientMessageIds.add(clientMessageId);

    fetch('/chatapp/send-group-message', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
        },
        body: 'roomName=' + encodeURIComponent(roomName) + '&sender=' + encodeURIComponent(username) + '&message=' + encodeURIComponent(message) + '&clientMessageId=' + encodeURIComponent(clientMessageId)
    })
        .then(response => response.json().then(body => ({ status: response.status, body: body })))
        .then(result => {
            if (result.status >= 400) {
                throw new Error(result.body && result.body.error ? result.body.error : 'Unable to send message');
            }

            const payload = {
                type: 'chat',
                roomName: roomName,
                sender: username,
                message: result.body.message || message,
                messageId: result.body.messageId || '',
                clientMessageId: result.body.clientMessageId || clientMessageId,
                timestamp: result.body.timestamp || ''
            };

            appendGroupRoomMessage(payload);
            if (groupChatState.ws && groupChatState.ws.readyState === WebSocket.OPEN) {
                groupChatState.ws.send(JSON.stringify(payload));
            }
            refreshGroupRooms(document.getElementById('groupRoomSearchInput') ? document.getElementById('groupRoomSearchInput').value.trim() : '');
        })
        .catch(error => {
            console.error('Error sending group message:', error);
            alert(error.message || 'Unable to send message');
            input.value = message;
        });
}

function initGroupChatUI() {
    const roomSearchInput = document.getElementById('groupRoomSearchInput');
    const createBtn = document.getElementById('createGroupBtn');
    const sendBtn = document.getElementById('sendGroupBtn');
    const messageInput = document.getElementById('groupMessageInput');
    const refreshBtn = document.getElementById('groupRefreshRoomsBtn');

    initGroupMemberSearch();

    if (roomSearchInput) {
        roomSearchInput.addEventListener('input', function() {
            searchGroupRooms(roomSearchInput.value.trim());
        });
    }

    if (createBtn) {
        createBtn.addEventListener('click', createGroupRoom);
    }

    if (sendBtn) {
        sendBtn.addEventListener('click', sendGroupMessage);
    }

    if (messageInput) {
        messageInput.addEventListener('keypress', function(event) {
            if (event.key === 'Enter') {
                event.preventDefault();
                sendGroupMessage();
            }
        });
    }

    if (refreshBtn) {
        refreshBtn.addEventListener('click', function() {
            refreshGroupRooms(roomSearchInput ? roomSearchInput.value.trim() : '');
            if (groupChatState.activeRoomName) {
                loadGroupRoomMessages(groupChatState.activeRoomName);
            }
        });
    }

    refreshGroupRooms();
}

if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initGroupChatUI);
} else {
    initGroupChatUI();
}
</script>