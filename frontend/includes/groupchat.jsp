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
                <div class="group-chat-header-main">
                    <button class="group-mobile-back-btn" id="groupMobileBackBtn" type="button" title="Back to chats">
                        <i class="fas fa-arrow-left"></i>
                    </button>
                    <div>
                        <h3 id="groupTitle" class="group-room-title-button" title="View members">Select or create a room</h3>
                        <div class="group-chat-meta" id="groupRoomMeta">Search rooms on the left or create a new one.</div>
                    </div>
                </div>
                <div class="group-chat-header-actions">
                    <button class="group-secondary-btn group-request-btn" id="groupRequestsBtn" type="button" style="display:none;">
                        Requests <span class="group-request-badge" id="requestBadge" style="display:none;">0</span>
                    </button>
                    <button class="group-secondary-btn" id="groupRefreshRoomsBtn" type="button">Refresh</button>
                </div>
            </div>

            <div class="group-requests-panel" id="groupRequestsPanel" style="display:none;">
                <div class="group-requests-title">Pending join requests</div>
                <div class="group-requests-list" id="groupRequestsList"></div>
            </div>

            <div class="group-members-panel" id="groupMembersPanel" style="display:none;">
                <div class="group-requests-title">Room members</div>
                <label class="group-admin-only-toggle" id="groupAdminOnlyToggleWrap" style="display:none;">
                    <input type="checkbox" id="groupAdminOnlyToggle">
                    <span>Admin-only message mode</span>
                </label>
                <div class="group-members-list" id="groupMembersList"></div>
            </div>

            <div class="group-empty-state" id="groupEmptyState">
                <div class="group-empty-card">
                    <i class="fas fa-comments"></i>
                    <h4>No room selected</h4>
                    <p>Create a unique room or join one from search to start chatting.</p>
                </div>
            </div>

            <div class="chat-messages group-room-messages" id="groupRoomMessages" style="display:none;"></div>

            <div class="group-admin-mode-notice" id="groupAdminModeNotice" style="display:none;">Only admin can message now</div>

            <div class="chat-input-container" id="groupChatInputBar" style="display:none;">
                <button id="groupEmojiBtn" class="group-emoji-btn" type="button" title="Emoji"><i class="fas fa-smile"></i></button>
                <input type="text" id="groupMessageInput" placeholder="Type a message...">
                <div class="emoji-picker-panel" id="groupEmojiPicker" style="display:none;"></div>
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

.group-chat-container.room-active .group-room-panel {
    display: none;
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

.group-room-title-button {
    cursor: pointer;
}

.group-room-title-button:hover {
    text-decoration: underline;
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

.group-chat-header-actions {
    display: flex;
    align-items: center;
    gap: 10px;
}

.group-request-btn {
    position: relative;
}

.group-request-badge {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    min-width: 20px;
    height: 20px;
    margin-left: 8px;
    padding: 0 6px;
    border-radius: 999px;
    background: #ef4444;
    color: #fff;
    font-size: 11px;
    font-weight: 700;
}

.group-requests-panel {
    margin: 14px 22px 0;
    padding: 16px;
    border: 1px solid var(--groupchat-line);
    border-radius: 18px;
    background: var(--groupchat-card);
}

.group-members-panel {
    margin: 14px 22px 0;
    padding: 16px;
    border: 1px solid var(--groupchat-line);
    border-radius: 18px;
    background: var(--groupchat-card);
}

.group-requests-title {
    font-size: 13px;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: 0.08em;
    color: var(--groupchat-muted);
    margin-bottom: 12px;
}

.group-requests-list {
    display: flex;
    flex-direction: column;
    gap: 10px;
}

.group-request-item {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 12px;
    padding: 12px 14px;
    border: 1px solid var(--groupchat-line);
    border-radius: 14px;
    background: rgba(255, 255, 255, 0.04);
}

.group-request-name {
    font-weight: 600;
    font-size: 14px;
}

.group-request-actions {
    display: flex;
    gap: 8px;
}

.group-members-list {
    display: flex;
    flex-direction: column;
    gap: 10px;
}

.group-member-item {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 12px;
    padding: 12px 14px;
    border: 1px solid var(--groupchat-line);
    border-radius: 14px;
    background: rgba(255, 255, 255, 0.04);
}

.group-member-name {
    font-weight: 600;
    font-size: 14px;
}

.group-admin-only-toggle {
    display: inline-flex;
    align-items: center;
    gap: 10px;
    margin-bottom: 12px;
    font-size: 13px;
    color: var(--groupchat-muted);
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

.group-chat-header-main {
    display: flex;
    align-items: flex-start;
    gap: 10px;
}

.group-mobile-back-btn {
    display: none;
    width: 34px;
    height: 34px;
    border-radius: 50%;
    border: 1px solid var(--groupchat-line);
    background: rgba(255, 255, 255, 0.08);
    color: var(--groupchat-text);
    cursor: pointer;
    flex-shrink: 0;
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
    position: relative;
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

.group-message-delete {
    position: absolute;
    top: 8px;
    right: 8px;
    width: 28px;
    height: 28px;
    border: none;
    border-radius: 50%;
    display: none;
    align-items: center;
    justify-content: center;
    background: rgba(0, 0, 0, 0.16);
    color: inherit;
    cursor: pointer;
}

.group-message-edit {
    position: absolute;
    top: 8px;
    right: 40px;
    width: 28px;
    height: 28px;
    border: none;
    border-radius: 50%;
    display: none;
    align-items: center;
    justify-content: center;
    background: rgba(0, 0, 0, 0.16);
    color: inherit;
    cursor: pointer;
}

.group-message-row.sent:hover .group-message-delete,
.group-message-row.sent:hover .group-message-edit {
    display: inline-flex;
}

.group-message-row.sent .group-message-bubble {
    padding-right: 76px;
}

.group-edited-label {
    display: inline-block;
    margin-left: 6px;
    font-size: 11px;
    opacity: 0.8;
}

.group-message-editing .group-message-text,
.group-message-editing .group-message-time,
.group-message-editing .group-message-sender {
    display: none;
}

.group-inline-editor {
    display: flex;
    flex-direction: column;
    gap: 10px;
    margin-top: 6px;
}

.group-inline-editor textarea {
    width: 100%;
    min-height: 82px;
    resize: vertical;
    border: 1px solid var(--groupchat-line);
    border-radius: 14px;
    padding: 12px 14px;
    background: rgba(255, 255, 255, 0.12);
    color: inherit;
    font: inherit;
    line-height: 1.45;
    outline: none;
}

.group-inline-editor textarea:focus {
    border-color: rgba(37, 211, 102, 0.65);
    box-shadow: 0 0 0 3px rgba(37, 211, 102, 0.12);
}

.group-inline-editor-actions {
    display: flex;
    justify-content: flex-end;
    gap: 8px;
}

.group-inline-editor-actions button {
    min-width: 84px;
    height: 38px;
    border-radius: 12px;
    border: 1px solid var(--groupchat-line);
    cursor: pointer;
    font-weight: 600;
}

.group-inline-editor-cancel {
    background: rgba(255, 255, 255, 0.08);
    color: inherit;
}

.group-inline-editor-save {
    background: linear-gradient(135deg, var(--groupchat-accent) 0%, var(--groupchat-accent-2) 100%);
    color: #fff;
    border-color: transparent;
}

.chat-input-container {
    display: flex;
    gap: 10px;
    align-items: center;
    padding: 16px 20px;
    border-top: 1px solid var(--groupchat-line);
    background: rgba(0, 0, 0, 0.06);
    position: relative;
}

.group-emoji-btn {
    width: 42px;
    height: 42px;
    border: 1px solid var(--groupchat-line);
    border-radius: 50%;
    background: rgba(255, 255, 255, 0.08);
    color: var(--groupchat-text);
    cursor: pointer;
    flex-shrink: 0;
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

.group-admin-mode-notice {
    align-self: center;
    margin: 8px auto;
    padding: 8px 14px;
    border-radius: 999px;
    border: 1px solid rgba(255, 255, 255, 0.2);
    background: rgba(0, 0, 0, 0.28);
    color: #fff;
    font-size: 12px;
    font-weight: 600;
}

.group-admin-mode-notice.flash {
    animation: groupNoticePop 0.35s ease;
}

@keyframes groupNoticePop {
    from {
        transform: translateY(8px);
        opacity: 0;
    }
    to {
        transform: translateY(0);
        opacity: 1;
    }
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

    .group-mobile-back-btn {
        display: inline-flex;
        align-items: center;
        justify-content: center;
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
    activeRoomCreator: null,
    adminOnlyMode: false,
    isActiveRoomCreator: false,
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

    container.classList.remove('room-active');
    container.style.display = 'flex';
    showCreateScreen();
    refreshGroupRooms();
    renderSelectedMembers();
}

function hideGroupChatModal() {
    stopGroupRoomRealtime();
    groupChatState.activeRoomName = null;
    groupChatState.activeRoomMembers = [];
    groupChatState.activeRoomCreator = null;
    groupChatState.adminOnlyMode = false;
    groupChatState.isActiveRoomCreator = false;
    const container = document.getElementById('groupChatContainer');
    if (container) {
        container.style.display = 'none';
    }
    toggleGroupRequestsPanel(false);
}

function showCreateScreen() {
    const container = document.getElementById('groupChatContainer');
    const emptyState = document.getElementById('groupEmptyState');
    const messages = document.getElementById('groupRoomMessages');
    const inputBar = document.getElementById('groupChatInputBar');
    const notice = document.getElementById('groupAdminModeNotice');
    if (container) container.classList.remove('room-active');
    if (emptyState) emptyState.style.display = 'flex';
    if (messages) messages.style.display = 'none';
    if (inputBar) inputBar.style.display = 'none';
    if (notice) notice.style.display = 'none';
    toggleGroupRequestsPanel(false);
    toggleGroupMembersPanel(false);
}

function goBackFromGroupChatMobile() {
    if (window.innerWidth <= 768) {
        hideGroupChatModal();
        if (typeof showRecentChatsPanel === 'function') {
            showRecentChatsPanel();
        }
        return;
    }

    hideGroupChatModal();
}

function showChatView() {
    const container = document.getElementById('groupChatContainer');
    const emptyState = document.getElementById('groupEmptyState');
    const messages = document.getElementById('groupRoomMessages');
    const inputBar = document.getElementById('groupChatInputBar');
    if (container) container.classList.add('room-active');
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

function buildGroupMessageHtml(text, edited) {
    return escapeHtml(text) + (edited ? '<span class="group-edited-label">edited</span>' : '');
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
        let actionLabel = 'Join room';
        if (room.isMember) {
            actionLabel = 'Open room';
        } else if (room.isPending) {
            actionLabel = 'Request sent';
        }

        item.innerHTML =
            '<div class="group-room-result-title">' + escapeHtml(room.roomName || 'Untitled room') + '</div>' +
            '<div class="group-room-result-meta">' + escapeHtml(room.lastMessage || 'No messages yet') + '</div>' +
            '<div class="group-room-result-meta">Members: ' + escapeHtml(memberSummary) + '</div>' +
            '<div class="group-room-result-meta">' + escapeHtml(actionLabel) + '</div>';

        item.addEventListener('click', function() {
            if (room.isMember) {
                openGroupRoom(room.roomName, room.members || [], room.admin || '', !!room.isAdmin, !!room.adminOnlyMode);
            } else if (room.isPending) {
                alert('Join request already sent to the room creator.');
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

function openGroupRoom(roomName, members, creator, isCreator, adminOnlyMode) {
    const cleanRoomName = (roomName || '').trim();
    if (!cleanRoomName) {
        return;
    }

    // Ensure only one selection type is active at a time.
    if (typeof activeChatUser !== 'undefined') {
        activeChatUser = null;
    }
    if (typeof displayedConversationUser !== 'undefined') {
        displayedConversationUser = null;
    }
    if (typeof stopActiveChatSync === 'function') {
        stopActiveChatSync();
    }

    groupChatState.activeRoomName = cleanRoomName;
    groupChatState.activeRoomMembers = Array.isArray(members) ? members : [];
    groupChatState.activeRoomCreator = (creator || '').trim();
    groupChatState.isActiveRoomCreator = Boolean(isCreator);
    groupChatState.adminOnlyMode = Boolean(adminOnlyMode);
    document.getElementById('groupTitle').textContent = cleanRoomName;
    document.getElementById('groupRoomMeta').textContent = groupChatState.activeRoomMembers.length ? ('Members: ' + groupChatState.activeRoomMembers.join(', ')) : 'Room members loaded from server';

    showChatView();
    applyGroupRoomPermissions();
    updateGroupRequestButton();
    clearGroupRoomState();
    loadGroupRoomMessages(cleanRoomName);
    startGroupRoomRealtime(cleanRoomName);
    syncActiveRoomPermissions();
    refreshGroupRooms(document.getElementById('groupRoomSearchInput') ? document.getElementById('groupRoomSearchInput').value.trim() : '');
    if (typeof loadRecentChats === 'function') {
        loadRecentChats();
    }
}

function findGroupMessageRow(messageId) {
    if (!messageId) {
        return null;
    }
    return document.querySelector('.group-message-bubble[data-message-id="' + messageId + '"]')?.closest('.group-message-row') || null;
}

function applyGroupMessageEdit(messageId, text, edited) {
    const row = findGroupMessageRow(messageId);
    if (!row) {
        return;
    }

    cancelGroupMessageInlineEdit(row);

    const textElement = row.querySelector('.group-message-text');
    if (textElement) {
        textElement.innerHTML = buildGroupMessageHtml(text, edited);
    }
}

function cancelGroupMessageInlineEdit(rowElement) {
    if (!rowElement) {
        return;
    }

    rowElement.classList.remove('group-message-editing');
    const editor = rowElement.querySelector('.group-inline-editor');
    if (editor) {
        editor.remove();
    }
}

function editGroupRoomMessage(messageId, rowElement) {
    const roomName = groupChatState.activeRoomName;
    const username = getGroupUsername();
    if (!roomName || !username || !messageId || !rowElement) {
        return;
    }

    const textElement = rowElement.querySelector('.group-message-text');
    if (!textElement) {
        return;
    }

    const originalText = textElement.textContent.replace(/edited\s*$/, '').trim();
    if (rowElement.classList.contains('group-message-editing')) {
        return;
    }

    rowElement.classList.add('group-message-editing');

    const bubble = rowElement.querySelector('.group-message-bubble');
    if (!bubble) {
        rowElement.classList.remove('group-message-editing');
        return;
    }

    const editor = document.createElement('div');
    editor.className = 'group-inline-editor';
    editor.innerHTML =
        '<textarea class="group-inline-editor-input"></textarea>' +
        '<div class="group-inline-editor-actions">' +
        '<button type="button" class="group-inline-editor-cancel">Cancel</button>' +
        '<button type="button" class="group-inline-editor-save">Save</button>' +
        '</div>';

    bubble.appendChild(editor);

    const input = editor.querySelector('.group-inline-editor-input');
    const cancelBtn = editor.querySelector('.group-inline-editor-cancel');
    const saveBtn = editor.querySelector('.group-inline-editor-save');
    input.value = originalText;
    input.focus();
    input.setSelectionRange(input.value.length, input.value.length);

    function finishEditing() {
        cancelGroupMessageInlineEdit(rowElement);
    }

    cancelBtn.addEventListener('click', finishEditing);

    input.addEventListener('keydown', function(event) {
        if (event.key === 'Escape') {
            event.preventDefault();
            finishEditing();
        }

        if (event.key === 'Enter' && !event.shiftKey) {
            event.preventDefault();
            saveBtn.click();
        }
    });

    saveBtn.addEventListener('click', function() {
        const cleanText = input.value.trim();
        if (!cleanText || cleanText === originalText) {
            finishEditing();
            return;
        }

        saveBtn.disabled = true;
        saveBtn.textContent = 'Saving...';

        fetch('/chatapp/edit-group-message', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
            },
            body: 'roomName=' + encodeURIComponent(roomName)
                + '&username=' + encodeURIComponent(username)
                + '&messageId=' + encodeURIComponent(messageId)
                + '&message=' + encodeURIComponent(cleanText)
        })
            .then(response => response.json().then(body => ({ status: response.status, body: body })))
            .then(result => {
                if (result.status >= 400 || !result.body || result.body.success !== true) {
                    throw new Error(result.body && result.body.error ? result.body.error : 'Unable to edit message');
                }

                applyGroupMessageEdit(messageId, cleanText, true);
                refreshGroupRooms(document.getElementById('groupRoomSearchInput') ? document.getElementById('groupRoomSearchInput').value.trim() : '');
            })
            .catch(error => {
                console.error('Error editing group message:', error);
                alert(error.message || 'Unable to edit message');
                saveBtn.disabled = false;
                saveBtn.textContent = 'Save';
            });
    });
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

            if (result.body && result.body.isMember) {
                openGroupRoom(result.body.roomName || cleanRoomName, [], '', false);
            } else {
                refreshGroupRooms(document.getElementById('groupRoomSearchInput') ? document.getElementById('groupRoomSearchInput').value.trim() : '');
                alert(result.body && result.body.message ? result.body.message : 'Join request sent to the room creator.');
            }
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
            openGroupRoom(createdRoomName, createdMembers, username, true);
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
                if (payload.type === 'edit' && payload.roomName && payload.roomName.toLowerCase() === roomName.toLowerCase()) {
                    applyGroupMessageEdit(payload.messageId, payload.message || '', true);
                    refreshGroupRooms(document.getElementById('groupRoomSearchInput') ? document.getElementById('groupRoomSearchInput').value.trim() : '');
                }
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
            if (typeof loadRecentChats === 'function') {
                loadRecentChats();
            }
            if (payload.sender && payload.sender.trim() !== getGroupUsername() && typeof window.notifyIncomingMessage === 'function') {
                const notificationKey = [
                    'group',
                    payload.roomName || '',
                    payload.messageId || '',
                    payload.clientMessageId || '',
                    payload.sender || '',
                    payload.timestamp || ''
                ].join('|');
                window.notifyIncomingMessage(payload.roomName || 'Group room', (payload.sender || 'Someone') + ': ' + (payload.message || ''), 'group', notificationKey, { roomName: payload.roomName || '' });
            }
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
            syncActiveRoomPermissions();
        }
    }, 3500);
}
function loadRequestBadge() {
    const roomName = groupChatState.activeRoomName;
    const username = getGroupUsername();
    if (!roomName || !groupChatState.isActiveRoomCreator || !username) return;

    fetch('/chatapp/pending-count?roomName=' + encodeURIComponent(roomName) + '&username=' + encodeURIComponent(username))
        .then(res => res.json())
        .then(data => {
            const badge = document.getElementById('requestBadge');
            const button = document.getElementById('groupRequestsBtn');

            if (!badge || !button) return;

            if (data.pending > 0) {
                button.style.display = 'inline-flex';
                badge.style.display = 'inline-block';
                badge.textContent = data.pending;
            } else {
                badge.style.display = 'none';
                button.style.display = groupChatState.isActiveRoomCreator ? 'inline-flex' : 'none';
            }
        });
}

setInterval(loadRequestBadge, 3000);
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
            const existingKeys = new Set(groupChatState.currentRoomKeys);
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
                clientMessageId: message.clientMessageId,
                edited: Boolean(message.edited)
            }));

            if (silent) {
                messages.forEach(function(message) {
                    const payload = {
                        roomName: cleanRoomName,
                        sender: message.sender,
                        message: message.message,
                        timestamp: message.timestamp,
                        messageId: message.id,
                        clientMessageId: message.clientMessageId
                    };
                    const key = groupMessageKey(payload);
                    const isOwnMessage = payload.sender && payload.sender.trim() === username;
                    if (!isOwnMessage && key && !existingKeys.has(key) && typeof window.notifyIncomingMessage === 'function') {
                        const notificationKey = [
                            'group',
                            payload.roomName || '',
                            payload.messageId || '',
                            payload.clientMessageId || '',
                            payload.sender || '',
                            payload.timestamp || ''
                        ].join('|');
                        window.notifyIncomingMessage(payload.roomName || 'Group room', (payload.sender || 'Someone') + ': ' + (payload.message || ''), 'group', notificationKey, { roomName: payload.roomName || '' });
                    }
                });
            }
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
    if (payload.messageId) {
        bubble.setAttribute('data-message-id', payload.messageId);
    }
    if (key) {
        bubble.setAttribute('data-message-key', key);
    }

    const sender = document.createElement('span');
    sender.className = 'group-message-sender';
    sender.textContent = isSent ? 'You' : (payload.sender || 'Unknown');

    const text = document.createElement('div');
    text.className = 'group-message-text';
    text.innerHTML = buildGroupMessageHtml(payload.message || '', Boolean(payload.edited));

    const time = document.createElement('span');
    time.className = 'group-message-time';
    time.textContent = payload.timestamp || '';

    if (isSent && payload.messageId) {
        const editBtn = document.createElement('button');
        editBtn.type = 'button';
        editBtn.className = 'group-message-edit';
        editBtn.setAttribute('title', 'Edit message');
        editBtn.innerHTML = '<i class="fas fa-pen"></i>';
        editBtn.addEventListener('click', function(event) {
            event.preventDefault();
            event.stopPropagation();
            editGroupRoomMessage(payload.messageId, row);
        });
        bubble.appendChild(editBtn);

        const deleteBtn = document.createElement('button');
        deleteBtn.type = 'button';
        deleteBtn.className = 'group-message-delete';
        deleteBtn.setAttribute('title', 'Delete message');
        deleteBtn.innerHTML = '<i class="fas fa-trash"></i>';
        deleteBtn.addEventListener('click', function(event) {
            event.preventDefault();
            event.stopPropagation();
            deleteGroupRoomMessage(payload.messageId, key, row);
        });
        bubble.appendChild(deleteBtn);
    }

    bubble.appendChild(sender);
    bubble.appendChild(text);
    bubble.appendChild(time);
    row.appendChild(bubble);
    messages.appendChild(row);
    messages.scrollTop = messages.scrollHeight;
}

function deleteGroupRoomMessage(messageId, messageKey, rowElement) {
    const roomName = groupChatState.activeRoomName;
    const username = getGroupUsername();
    if (!roomName || !username || !messageId || !rowElement) {
        return;
    }

    fetch('/chatapp/delete-group-message', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
        },
        body: 'roomName=' + encodeURIComponent(roomName)
            + '&username=' + encodeURIComponent(username)
            + '&messageId=' + encodeURIComponent(messageId)
    })
        .then(response => response.json().then(body => ({ status: response.status, body: body })))
        .then(result => {
            if (result.status >= 400 || !result.body || result.body.success !== true) {
                throw new Error(result.body && result.body.error ? result.body.error : 'Unable to delete message');
            }

            rowElement.remove();
            if (messageKey) {
                groupChatState.currentRoomKeys.delete(messageKey);
            }
            const messages = document.getElementById('groupRoomMessages');
            if (messages && messages.children.length === 0) {
                showCreateScreen();
            }
            refreshGroupRooms(document.getElementById('groupRoomSearchInput') ? document.getElementById('groupRoomSearchInput').value.trim() : '');
        })
        .catch(error => {
            console.error('Error deleting group message:', error);
            alert(error.message || 'Unable to delete message');
        });
}

function sendGroupMessage() {
    const input = document.getElementById('groupMessageInput');
    if (!input || !groupChatState.activeRoomName) {
        return;
    }

    if (groupChatState.adminOnlyMode && !groupChatState.isActiveRoomCreator) {
        alert('Admin-only mode is enabled. Only room admin can send messages.');
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
            if (typeof loadRecentChats === 'function') {
                loadRecentChats();
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
    const requestsBtn = document.getElementById('groupRequestsBtn');
    const title = document.getElementById('groupTitle');
    const adminOnlyToggle = document.getElementById('groupAdminOnlyToggle');
    const mobileBackBtn = document.getElementById('groupMobileBackBtn');
    const groupEmojiBtn = document.getElementById('groupEmojiBtn');
    const groupEmojiPicker = document.getElementById('groupEmojiPicker');

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

    if (groupEmojiBtn && groupEmojiPicker && messageInput && typeof buildEmojiPicker === 'function') {
        buildEmojiPicker(groupEmojiPicker, messageInput);

        groupEmojiBtn.addEventListener('click', function(event) {
            event.preventDefault();
            event.stopPropagation();
            groupEmojiPicker.style.display = groupEmojiPicker.style.display === 'block' ? 'none' : 'block';
        });

        document.addEventListener('click', function(event) {
            if (!groupEmojiPicker.contains(event.target) && event.target !== groupEmojiBtn) {
                groupEmojiPicker.style.display = 'none';
            }
        });
    }

    if (refreshBtn) {
        refreshBtn.addEventListener('click', function() {
            refreshGroupRooms(roomSearchInput ? roomSearchInput.value.trim() : '');
            if (groupChatState.activeRoomName) {
                loadGroupRoomMessages(groupChatState.activeRoomName);
                loadGroupRoomMembers();
                syncActiveRoomPermissions();
            }
            if (groupChatState.isActiveRoomCreator) {
                loadPendingRequests();
            }
        });
    }

    if (requestsBtn) {
        requestsBtn.addEventListener('click', function() {
            const panel = document.getElementById('groupRequestsPanel');
            const isVisible = panel && panel.style.display !== 'none';
            toggleGroupRequestsPanel(!isVisible);
            if (!isVisible) {
                loadPendingRequests();
            }
        });
    }

    if (title) {
        title.addEventListener('click', function() {
            if (!groupChatState.activeRoomName) {
                return;
            }
            const panel = document.getElementById('groupMembersPanel');
            const isVisible = panel && panel.style.display !== 'none';
            toggleGroupMembersPanel(!isVisible);
            if (!isVisible) {
                loadGroupRoomMembers();
            }
        });
    }

    if (adminOnlyToggle) {
        adminOnlyToggle.addEventListener('change', function() {
            toggleAdminOnlyMode(Boolean(adminOnlyToggle.checked));
        });
    }

    if (mobileBackBtn) {
        mobileBackBtn.addEventListener('click', goBackFromGroupChatMobile);
    }

    refreshGroupRooms();
}

function updateGroupRequestButton() {
    const requestsBtn = document.getElementById('groupRequestsBtn');
    if (!requestsBtn) {
        return;
    }
    requestsBtn.style.display = groupChatState.isActiveRoomCreator ? 'inline-flex' : 'none';
    if (groupChatState.isActiveRoomCreator) {
        loadRequestBadge();
    } else {
        toggleGroupRequestsPanel(false);
    }
}

function applyGroupRoomPermissions() {
    const input = document.getElementById('groupMessageInput');
    const sendBtn = document.getElementById('sendGroupBtn');
    const inputBar = document.getElementById('groupChatInputBar');
    const notice = document.getElementById('groupAdminModeNotice');
    const canSend = !groupChatState.adminOnlyMode || groupChatState.isActiveRoomCreator;

    if (inputBar) {
        inputBar.style.display = canSend ? 'flex' : 'none';
    }

    if (notice) {
        notice.style.display = !canSend && groupChatState.activeRoomName ? 'block' : 'none';
    }

    if (input) {
        input.disabled = !canSend;
        input.placeholder = canSend
            ? 'Type a message...'
            : 'Admin-only mode is enabled. Only room admin can send messages.';
    }

    if (sendBtn) {
        sendBtn.disabled = !canSend;
        sendBtn.style.opacity = canSend ? '1' : '0.6';
        sendBtn.style.cursor = canSend ? 'pointer' : 'not-allowed';
    }
}

function flashAdminModeNotice() {
    const notice = document.getElementById('groupAdminModeNotice');
    if (!notice) {
        return;
    }

    notice.classList.remove('flash');
    void notice.offsetWidth;
    notice.classList.add('flash');
}

function syncActiveRoomPermissions() {
    const roomName = groupChatState.activeRoomName;
    const username = getGroupUsername();
    if (!roomName || !username) {
        return;
    }

    fetch('/chatapp/group-room-members?roomName=' + encodeURIComponent(roomName) + '&username=' + encodeURIComponent(username), { cache: 'no-store' })
        .then(response => response.json().then(body => ({ status: response.status, body: body })))
        .then(result => {
            if (result.status >= 400 || !result.body || result.body.success !== true) {
                return;
            }

            const previousAdminOnlyMode = groupChatState.adminOnlyMode;
            groupChatState.activeRoomMembers = Array.isArray(result.body.members) ? result.body.members : groupChatState.activeRoomMembers;
            groupChatState.activeRoomCreator = (result.body.creator || '').trim();
            groupChatState.isActiveRoomCreator = Boolean(result.body.isCreator);
            groupChatState.adminOnlyMode = Boolean(result.body.adminOnlyMode);

            if (!groupChatState.isActiveRoomCreator && !previousAdminOnlyMode && groupChatState.adminOnlyMode) {
                flashAdminModeNotice();
            }

            applyGroupRoomPermissions();
        })
        .catch(() => {
            // Ignore temporary sync errors.
        });
}

function toggleGroupRequestsPanel(show) {
    const panel = document.getElementById('groupRequestsPanel');
    if (!panel) {
        return;
    }
    panel.style.display = show && groupChatState.isActiveRoomCreator ? 'block' : 'none';
    if (show) {
        toggleGroupMembersPanel(false);
    }
}

function toggleGroupMembersPanel(show) {
    const panel = document.getElementById('groupMembersPanel');
    if (!panel) {
        return;
    }
    panel.style.display = show && groupChatState.activeRoomName ? 'block' : 'none';
    if (show) {
        toggleGroupRequestsPanel(false);
    }
}

function loadGroupRoomMembers() {
    const roomName = groupChatState.activeRoomName;
    const username = getGroupUsername();
    const list = document.getElementById('groupMembersList');
    const toggleWrap = document.getElementById('groupAdminOnlyToggleWrap');
    const toggleInput = document.getElementById('groupAdminOnlyToggle');

    if (!roomName || !username || !list) {
        return;
    }

    fetch('/chatapp/group-room-members?roomName=' + encodeURIComponent(roomName) + '&username=' + encodeURIComponent(username), { cache: 'no-store' })
        .then(response => response.json().then(body => ({ status: response.status, body: body })))
        .then(result => {
            if (result.status >= 400 || !result.body || result.body.success !== true) {
                throw new Error(result.body && result.body.error ? result.body.error : 'Unable to load room members');
            }

            groupChatState.activeRoomMembers = Array.isArray(result.body.members) ? result.body.members : [];
            groupChatState.activeRoomCreator = (result.body.creator || '').trim();
            groupChatState.isActiveRoomCreator = Boolean(result.body.isCreator);
            groupChatState.adminOnlyMode = Boolean(result.body.adminOnlyMode);

            if (toggleWrap && toggleInput) {
                toggleWrap.style.display = groupChatState.isActiveRoomCreator ? 'inline-flex' : 'none';
                toggleInput.checked = groupChatState.adminOnlyMode;
            }

            renderGroupMembers(groupChatState.activeRoomMembers);
            applyGroupRoomPermissions();
        })
        .catch(error => {
            console.error('Error loading room members:', error);
            list.innerHTML = '<div class="group-room-result-meta">Unable to load members.</div>';
        });
}

function renderGroupMembers(members) {
    const list = document.getElementById('groupMembersList');
    if (!list) {
        return;
    }

    list.innerHTML = '';
    const cleanMembers = Array.isArray(members) ? members : [];
    if (cleanMembers.length === 0) {
        list.innerHTML = '<div class="group-room-result-meta">No members found.</div>';
        return;
    }

    cleanMembers.forEach(function(member) {
        const item = document.createElement('div');
        item.className = 'group-member-item';

        const isCreator = groupChatState.activeRoomCreator && member === groupChatState.activeRoomCreator;
        const canRemove = groupChatState.isActiveRoomCreator && !isCreator;

        item.innerHTML = '<div class="group-member-name">' + escapeHtml(member) + (isCreator ? ' (Admin)' : '') + '</div><div class="group-request-actions"></div>';
        const actions = item.querySelector('.group-request-actions');

        if (canRemove) {
            const removeBtn = document.createElement('button');
            removeBtn.type = 'button';
            removeBtn.className = 'group-secondary-btn';
            removeBtn.textContent = 'Remove';
            removeBtn.addEventListener('click', function() {
                removeGroupMember(member, removeBtn);
            });
            actions.appendChild(removeBtn);
        }

        list.appendChild(item);
    });
}

function removeGroupMember(usernameToRemove, button) {
    const roomName = groupChatState.activeRoomName;
    const creator = getGroupUsername();
    if (!roomName || !creator || !usernameToRemove) {
        return;
    }

    if (button) {
        button.disabled = true;
        button.textContent = 'Removing...';
    }

    fetch('/chatapp/remove-group-member', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
        },
        body: 'roomName=' + encodeURIComponent(roomName)
            + '&creator=' + encodeURIComponent(creator)
            + '&username=' + encodeURIComponent(usernameToRemove)
    })
        .then(response => response.json().then(body => ({ status: response.status, body: body })))
        .then(result => {
            if (result.status >= 400 || !result.body || result.body.success !== true) {
                throw new Error(result.body && result.body.error ? result.body.error : 'Unable to remove member');
            }

            groupChatState.activeRoomMembers = Array.isArray(result.body.members) ? result.body.members : groupChatState.activeRoomMembers;
            document.getElementById('groupRoomMeta').textContent = groupChatState.activeRoomMembers.length
                ? ('Members: ' + groupChatState.activeRoomMembers.join(', '))
                : 'Room members loaded from server';
            renderGroupMembers(groupChatState.activeRoomMembers);
            refreshGroupRooms(document.getElementById('groupRoomSearchInput') ? document.getElementById('groupRoomSearchInput').value.trim() : '');
        })
        .catch(error => {
            console.error('Error removing member:', error);
            alert(error.message || 'Unable to remove member');
            if (button) {
                button.disabled = false;
                button.textContent = 'Remove';
            }
        });
}

function toggleAdminOnlyMode(enabled) {
    const roomName = groupChatState.activeRoomName;
    const creator = getGroupUsername();
    if (!roomName || !creator || !groupChatState.isActiveRoomCreator) {
        return;
    }

    fetch('/chatapp/toggle-admin-only-mode', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
        },
        body: 'roomName=' + encodeURIComponent(roomName)
            + '&creator=' + encodeURIComponent(creator)
            + '&enabled=' + encodeURIComponent(enabled ? 'true' : 'false')
    })
        .then(response => response.json().then(body => ({ status: response.status, body: body })))
        .then(result => {
            if (result.status >= 400 || !result.body || result.body.success !== true) {
                throw new Error(result.body && result.body.error ? result.body.error : 'Unable to update admin-only mode');
            }
            groupChatState.adminOnlyMode = Boolean(result.body.adminOnlyMode);
            applyGroupRoomPermissions();
            refreshGroupRooms(document.getElementById('groupRoomSearchInput') ? document.getElementById('groupRoomSearchInput').value.trim() : '');
        })
        .catch(error => {
            console.error('Error toggling admin-only mode:', error);
            alert(error.message || 'Unable to update admin-only mode');
            const toggle = document.getElementById('groupAdminOnlyToggle');
            if (toggle) {
                toggle.checked = groupChatState.adminOnlyMode;
            }
        });
}

function loadPendingRequests() {
    const roomName = groupChatState.activeRoomName;
    const username = getGroupUsername();
    const list = document.getElementById('groupRequestsList');

    if (!roomName || !username || !groupChatState.isActiveRoomCreator || !list) {
        return;
    }

    fetch('/chatapp/pending-requests?roomName=' + encodeURIComponent(roomName) + '&username=' + encodeURIComponent(username), { cache: 'no-store' })
        .then(response => response.json().then(body => ({ status: response.status, body: body })))
        .then(result => {
            if (result.status >= 400) {
                throw new Error(result.body && result.body.error ? result.body.error : 'Unable to load pending requests');
            }
            renderPendingRequests(Array.isArray(result.body) ? result.body : []);
            loadRequestBadge();
        })
        .catch(error => {
            console.error('Error loading pending requests:', error);
        });
}

function renderPendingRequests(requests) {
    const list = document.getElementById('groupRequestsList');
    if (!list) {
        return;
    }

    list.innerHTML = '';
    if (!requests || requests.length === 0) {
        list.innerHTML = '<div class="group-room-result-meta">No pending requests right now.</div>';
        return;
    }

    requests.forEach(function(requestedUser) {
        const item = document.createElement('div');
        item.className = 'group-request-item';
        item.innerHTML =
            '<div class="group-request-name">' + escapeHtml(requestedUser) + '</div>' +
            '<div class="group-request-actions"></div>';

        const actions = item.querySelector('.group-request-actions');
        const approveBtn = document.createElement('button');
        approveBtn.type = 'button';
        approveBtn.className = 'group-primary-btn';
        approveBtn.textContent = 'Approve';
        approveBtn.addEventListener('click', function() {
            approvePendingRequest(requestedUser, approveBtn);
        });

        const declineBtn = document.createElement('button');
        declineBtn.type = 'button';
        declineBtn.className = 'group-secondary-btn';
        declineBtn.textContent = 'Decline';
        declineBtn.addEventListener('click', function() {
            declinePendingRequest(requestedUser, declineBtn);
        });

        actions.appendChild(approveBtn);
        actions.appendChild(declineBtn);
        list.appendChild(item);
    });
}

function declinePendingRequest(requestedUser, button) {
    const roomName = groupChatState.activeRoomName;
    const creator = getGroupUsername();
    if (!roomName || !creator || !requestedUser) {
        return;
    }

    if (button) {
        button.disabled = true;
        button.textContent = 'Declining...';
    }

    fetch('/chatapp/decline-join-request', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
        },
        body: 'roomName=' + encodeURIComponent(roomName)
            + '&creator=' + encodeURIComponent(creator)
            + '&username=' + encodeURIComponent(requestedUser)
    })
        .then(response => response.json().then(body => ({ status: response.status, body: body })))
        .then(result => {
            if (result.status >= 400 || !result.body || result.body.success !== true) {
                throw new Error(result.body && result.body.error ? result.body.error : 'Unable to decline request');
            }
            loadPendingRequests();
        })
        .catch(error => {
            console.error('Error declining join request:', error);
            alert(error.message || 'Unable to decline request');
            if (button) {
                button.disabled = false;
                button.textContent = 'Decline';
            }
        });
}

function approvePendingRequest(requestedUser, button) {
    const roomName = groupChatState.activeRoomName;
    const creator = getGroupUsername();
    if (!roomName || !creator || !requestedUser) {
        return;
    }

    if (button) {
        button.disabled = true;
        button.textContent = 'Approving...';
    }

    fetch('/chatapp/approve-join-request', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
        },
        body: 'roomName=' + encodeURIComponent(roomName)
            + '&creator=' + encodeURIComponent(creator)
            + '&username=' + encodeURIComponent(requestedUser)
    })
        .then(response => response.json().then(body => ({ status: response.status, body: body })))
        .then(result => {
            if (result.status >= 400 || !result.body || result.body.success !== true) {
                throw new Error(result.body && result.body.error ? result.body.error : 'Unable to approve request');
            }

            groupChatState.activeRoomMembers = Array.isArray(result.body.members) ? result.body.members : groupChatState.activeRoomMembers;
            document.getElementById('groupRoomMeta').textContent = groupChatState.activeRoomMembers.length
                ? ('Members: ' + groupChatState.activeRoomMembers.join(', '))
                : 'Room members loaded from server';

            loadPendingRequests();
            refreshGroupRooms(document.getElementById('groupRoomSearchInput') ? document.getElementById('groupRoomSearchInput').value.trim() : '');
        })
        .catch(error => {
            console.error('Error approving join request:', error);
            alert(error.message || 'Unable to approve request');
            if (button) {
                button.disabled = false;
                button.textContent = 'Approve';
            }
        });
}

if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initGroupChatUI);
} else {
    initGroupChatUI();
}
</script>
