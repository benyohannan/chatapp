<!-- ================= GROUP CHAT CONTAINER ================= -->
<div class="group-chat-container" id="groupChatContainer" style="display:none;">

    <!-- Sidebar for group members -->
    

    <!-- Chat area -->
    <div class="group-chat-area">
        <div class="group-create-screen" id="groupCreateScreen">
            <div class="create-header">
                <h3>Create chat room</h3>
                <i class="fas fa-times" onclick="hideGroupChatModal()" title="Close" style="cursor: pointer; font-size: 20px;"></i>
            </div>
            <div class="create-body">
                <label for="groupNameInput">Group name</label>
                <input type="text" id="groupNameInput" placeholder="Enter a group name">

                <label for="groupMembersInput">Members</label>
                  <div class="member-list" id="memberList">
            <div class="member-item">John Doe</div>
            <div class="member-item">Sarah Wilson</div>
            <div class="member-item">Alex Johnson</div>
            <div class="member-item">Emma Davis</div>
        </div>
                <textarea id="groupMembersInput" placeholder="Add members"></textarea>

                <button id="createGroupBtn">Create Group</button>
            </div>
        </div>

        <div class="group-chat-view" id="groupChatView" style="display:none;">
            <!-- Chat header -->
            <div class="chat-header">
                <div style="display: flex; justify-content: space-between; align-items: center; width: 100%;">
                    <h3 id="groupTitle">My Group Chat</h3>
                    <i class="fas fa-times" onclick="hideGroupChatModal()" title="Close" style="cursor: pointer; font-size: 20px; color: white;"></i>
                </div>
            </div>

            <!-- Messages -->
            <div class="chat-messages" id="groupRoomMessages">
                <!-- messages will appear here -->
            </div>

            <!-- Chat input -->
            <div class="chat-input-container">
                <input type="text" id="groupMessageInput" placeholder="Type a message...">
                <button id="sendGroupBtn"><i class="fas fa-paper-plane"></i></button>
            </div>
        </div>
    </div>
</div>

<!-- ================= GROUP CHAT CSS ================= -->
<style>
:root {
    --groupchat-create-bg: linear-gradient(135deg, #0f1720 0%, #172a32 100%);
    --groupchat-card-bg: rgba(255, 255, 255, 0.04);
    --groupchat-form-bg: #111b21;
    --groupchat-input-bg: #19232c;
    --groupchat-input-border: #2a3942;
    --groupchat-input-color: #e9edef;
    --groupchat-input-focus-bg: #0b141a;
    --groupchat-message-bg: var(--chat-bg);
    --groupchat-bg-alt: #0b141a;
    --groupchat-header-text: white;
}

.light-mode {
    --groupchat-create-bg: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
    --groupchat-card-bg: #ffffff;
    --groupchat-form-bg: #ffffff;
    --groupchat-input-bg: #f8f9fa;
    --groupchat-input-border: #e0e6ed;
    --groupchat-input-color: #2c3e50;
    --groupchat-input-focus-bg: #ffffff;
    --groupchat-message-bg: linear-gradient(to bottom, #f0f2f5 0%, #eceff1 100%);
    --groupchat-bg-alt: #f5f7fa;
    --groupchat-header-text: #111b21;
}

.group-chat-container {
    display: flex;
    position: absolute;
    top: 0;
    left: 400px;
    right: 0;
    bottom: 0;
    z-index: 9999;
    align-items: stretch;
    justify-content: stretch;
    background: transparent;
    padding: 0;
    font-family: Arial, sans-serif;
}
.group-chat-container .group-sidebar,
.group-chat-container .group-chat-area {
    height: 100vh;
    max-height: none;
}

/* Chat area */
.group-chat-area {
    flex: 1;
    display: flex;
    flex-direction: column;
    width: 100%;
    height: 100%;
}

.group-create-screen,
.group-chat-view {
    display: flex;
    flex-direction: column;
    flex: 1;
    background: var(--groupchat-form-bg);
    border-radius: 0;
    overflow: hidden;
    width: 100%;
    height: 100%;
    color: var(--text-primary);
}

.group-create-screen {
    padding: 40px;
    gap: 12px;
    width: 100%;
    height: 100%;
    max-width: none;
    max-height: none;
    background: var(--groupchat-create-bg);
    overflow-y: auto;
}

.group-create-screen .create-header {
    padding-bottom: 20px;
    border-bottom: 2px solid rgba(26, 188, 156, 0.2);
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 10px;
}

.group-create-screen .create-header h3 {
    margin: 0;
    font-size: 28px;
    color: var(--text-primary);
    font-weight: 600;
    letter-spacing: -0.5px;
}

.group-create-screen .create-body {
    display: flex;
    flex-direction: column;
    gap: 15px;
    padding-top: 10px;
    background: var(--groupchat-card-bg);
    padding: 30px;
    border-radius: 12px;
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.12);
}

.group-create-screen label {
    font-weight: 600;
    color: var(--text-secondary);
    font-size: 14px;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    margin-bottom: 5px;
}

.group-create-screen input,
.group-create-screen textarea {
    width: 100%;
    padding: 12px 15px;
    border: 2px solid var(--groupchat-input-border);
    border-radius: 8px;
    font-size: 14px;
    font-family: inherit;
    transition: all 0.3s ease;
    background: var(--groupchat-input-bg);
    color: var(--groupchat-input-color);
}

.group-create-screen input::placeholder,
.group-create-screen textarea::placeholder {
    color: var(--text-secondary);
}

.group-create-screen input:focus,
.group-create-screen textarea:focus {
    outline: none;
    border-color: var(--green-primary);
    background: var(--groupchat-input-focus-bg);
    box-shadow: 0 0 0 3px rgba(26, 188, 156, 0.1);
}

.group-create-screen textarea {
    min-height: 100px;
    resize: vertical;
}

.group-create-screen button {
    width: fit-content;
    padding: 12px 32px;
    border: none;
    border-radius: 8px;
    background: linear-gradient(135deg, var(--green-primary) 0%, var(--green-secondary) 100%);
    color: white;
    cursor: pointer;
    font-weight: 600;
    font-size: 15px;
    transition: all 0.3s ease;
    box-shadow: 0 4px 15px rgba(26, 188, 156, 0.3);
    align-self: flex-start;
    text-transform: uppercase;
    letter-spacing: 0.5px;
}

.group-create-screen button:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 20px rgba(26, 188, 156, 0.4);
    background: linear-gradient(135deg, var(--green-secondary) 0%, #138d78 100%);
}

.group-chat-area .chat-header {
    padding: 18px 20px;
    background: linear-gradient(135deg, var(--green-primary) 0%, var(--green-secondary) 100%);
    color: var(--groupchat-header-text);
    font-weight: 600;
    font-size: 18px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.group-chat-area .chat-header i {
    color: var(--groupchat-header-text);
}

.group-chat-area .chat-messages {
    flex: 1;
    padding: 20px;
    overflow-y: auto;
    background: var(--groupchat-message-bg);
}

.group-chat-area .message {
    margin-bottom: 12px;
    display: flex;
    animation: messageSlideIn 0.3s ease-out;
}

@keyframes messageSlideIn {
    from {
        opacity: 0;
        transform: translateY(10px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

.group-chat-area .message.sent {
    justify-content: flex-end;
}

.group-chat-area .message.received {
    justify-content: flex-start;
}

.group-chat-area .message .message-bubble {
    display: inline-block;
    padding: 10px 16px;
    border-radius: 18px;
    max-width: 70%;
    word-wrap: break-word;
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
    font-size: 14px;
    line-height: 1.4;
}

.group-chat-area .message.received .message-bubble {
    background: var(--secondary-bg);
    color: var(--text-primary);
    border: 1px solid var(--border-color);
}

.group-chat-area .message.sent .message-bubble {
    background: linear-gradient(135deg, var(--green-primary) 0%, var(--green-secondary) 100%);
    color: white;
}

/* Chat input */
.group-chat-area .chat-input-container {
    display: flex;
    padding: 15px 20px;
    background: var(--secondary-bg);
    border-top: 2px solid var(--border-color);
    gap: 10px;
    align-items: center;
}

.group-chat-area .chat-input-container input {
    flex: 1;
    padding: 12px 16px;
    border-radius: 24px;
    border: 2px solid var(--border-color);
    outline: none;
    font-size: 14px;
    font-family: inherit;
    background: var(--groupchat-input-bg);
    color: var(--groupchat-input-color);
    transition: all 0.3s ease;
}

.group-chat-area .chat-input-container input:focus {
    border-color: var(--green-primary);
    background: var(--groupchat-input-focus-bg);
    box-shadow: 0 0 0 3px rgba(26, 188, 156, 0.1);
}

.group-chat-area .chat-input-container button {
    width: 44px;
    height: 44px;
    border: none;
    background: linear-gradient(135deg, var(--green-primary) 0%, var(--green-secondary) 100%);
    color: white;
    border-radius: 50%;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: all 0.3s ease;
    box-shadow: 0 2px 8px rgba(26, 188, 156, 0.3);
    flex-shrink: 0;
}

.group-chat-area .chat-input-container button:hover {
    transform: scale(1.05);
    box-shadow: 0 4px 12px rgba(26, 188, 156, 0.4);
}

.group-chat-area .chat-input-container button:active {
    transform: scale(0.95);
}

/* Member List Styling */
.member-list {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(120px, 1fr));
    gap: 12px;
    margin: 15px 0;
    padding: 15px;
    background: var(--secondary-bg);
    border-radius: 8px;
}

.member-item {
    padding: 12px 15px;
    background: var(--groupchat-card-bg);
    border: 2px solid var(--border-color);
    border-radius: 8px;
    cursor: pointer;
    font-weight: 500;
    color: var(--text-primary);
    text-align: center;
    transition: all 0.3s ease;
    user-select: none;
    font-size: 13px;
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
}

.member-item:hover {
    background: var(--hover-bg);
    border-color: var(--green-primary);
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(26, 188, 156, 0.2);
}

.member-item.selected {
    background: linear-gradient(135deg, var(--green-primary) 0%, var(--green-secondary) 100%);
    color: white;
    border-color: var(--green-secondary);
    box-shadow: 0 4px 15px rgba(26, 188, 156, 0.3);
}
</style>

<!-- ================= GROUP CHAT JS ================= -->
<script>
let groupCreated = false;
let selectedMembers = [];
function showGroupChatModal() {
    const container = document.getElementById('groupChatContainer');
    if (!container) return;
    container.style.display = 'flex';
    showCreateScreen(); // always start with create screen
}
// Toggle selection of a member
function toggleMemberSelection(memberItem) {
    const name = memberItem.textContent.trim();
    const index = selectedMembers.indexOf(name);

    if (index === -1) {
        selectedMembers.push(name);
        memberItem.classList.add('selected');
    } else {
        selectedMembers.splice(index, 1);
        memberItem.classList.remove('selected');
    }

    // Optional: display selected members in textarea
    const membersInput = document.getElementById('groupMembersInput');
    if (membersInput) membersInput.value = selectedMembers.join(', ');
}

// Attach click event to all member-items
function initMemberSelection() {
    document.querySelectorAll('#memberList .member-item').forEach(item => {
        item.addEventListener('click', () => toggleMemberSelection(item));
    });
}

// Create group
function createGroup() {
    const groupNameInput = document.getElementById('groupNameInput');
    const groupTitle = document.getElementById('groupTitle');

    const name = groupNameInput.value.trim();
    if (!name) {
        alert('Please enter a group name.');
        return;
    }

    if (selectedMembers.length === 0) {
        alert('Please select at least one member.');
        return;
    }

    // Update UI
    groupCreated = true;
    if (groupTitle) groupTitle.textContent = name;
    showChatView();

    // Show system message
    appendGroupMessage('System', `Group "${name}" created with members: ${selectedMembers.join(', ')}`, 'received');

    // Clear input
    groupNameInput.value = '';
    selectedMembers = [];
    document.getElementById('groupMembersInput').value = '';
    document.querySelectorAll('#memberList .member-item.selected').forEach(item => item.classList.remove('selected'));
}

// Append message
function appendGroupMessage(sender, text, type = 'received') {
    const messages = document.getElementById('groupRoomMessages');
    const msgDiv = document.createElement('div');
    msgDiv.className = 'message ' + type;
    msgDiv.innerHTML = `<div class="message-bubble"><b>${sender}</b>: ${text}</div>`;
    messages.appendChild(msgDiv);
    messages.scrollTop = messages.scrollHeight;
}

// Send message
function sendGroupMessage() {
    const input = document.getElementById('groupMessageInput');
    const text = input.value.trim();
    if (!text) return;

    appendGroupMessage('You', text, 'sent');
    input.value = '';
}

// Show/hide screens
function showCreateScreen() {
    document.getElementById('groupCreateScreen').style.display = 'flex';
    document.getElementById('groupChatView').style.display = 'none';
}

function showChatView() {
    document.getElementById('groupCreateScreen').style.display = 'none';
    document.getElementById('groupChatView').style.display = 'flex';
}

function hideGroupChatModal() {
    document.getElementById('groupChatContainer').style.display = 'none';
}

// Init everything on page load
document.addEventListener('DOMContentLoaded', () => {
    initMemberSelection();

    document.getElementById('createGroupBtn').addEventListener('click', createGroup);
    document.getElementById('sendGroupBtn').addEventListener('click', sendGroupMessage);

    document.getElementById('groupMessageInput').addEventListener('keypress', e => {
        if (e.key === 'Enter') {
            e.preventDefault();
            sendGroupMessage();
        }
    });
});
</script>