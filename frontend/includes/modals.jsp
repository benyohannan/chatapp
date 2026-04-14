<!-- Clear Chat Modal -->
<div class="modal-overlay" id="clearChatModal">
    <div class="modal">
        <div class="modal-header">
            <div class="modal-icon warning">
                <i class="fas fa-broom"></i>
            </div>
            <div class="modal-title">Clear Chat</div>
        </div>
        <div class="modal-content">
            Are you sure you want to clear all messages in this chat? This action cannot be undone.
        </div>
        <div class="modal-actions">
            <button class="modal-btn cancel" id="clearChatCancel">Cancel</button>
            <button class="modal-btn confirm" id="clearChatConfirm">Clear</button>
        </div>
    </div>
</div>

<div class="context-menu" id="contextMenu" style="display:none;">
    <div class="context-menu-item" id="replyOption">
        <i class="fas fa-reply"></i>
        <span>Reply</span>
    </div>
    <div class="context-menu-item" id="editOption">
        <i class="fas fa-pen"></i>
        <span>Edit</span>
    </div>
    <div class="context-menu-item" id="copyOption">
        <i class="fas fa-copy"></i>
        <span>Copy</span>
    </div>
    <div class="context-menu-item danger" id="deleteOption">
        <i class="fas fa-trash"></i>
        <span>Delete</span>
    </div>
</div>

<div class="modal-overlay" id="userSettingsModal">
    <div class="settings-modal">
        <div class="settings-modal-header">
            <button class="settings-back-btn" id="settingsBackBtn">
                <i class="fas fa-arrow-left"></i>
            </button>
            <h3>Your Profile</h3>
            <button class="settings-close-btn" id="settingsCloseBtn">
                <i class="fas fa-times"></i>
            </button>
        </div>
        <div id="settingsContent"></div>
    </div>
</div>

<div class="modal-overlay" id="editProfileModal">
    <div class="edit-profile-modal">
        <div class="edit-profile-header">
            <button class="edit-profile-back-btn" id="editProfileBackBtn">
                <i class="fas fa-arrow-left"></i>
            </button>
            <h3>Edit Profile</h3>
            <button class="edit-profile-save-btn" id="editProfileSaveBtn">Save</button>
        </div>
        <div id="editProfileContent"></div>
    </div>
</div>

<!-- Profile Modal -->
<div class="modal-overlay" id="profileModal">
    <div class="profile-modal">
        <div class="profile-modal-header">
            <button class="profile-back-btn" id="profileBackBtn">
                <i class="fas fa-arrow-left"></i>
            </button>
            <h3>Contact Info</h3>
            <button class="profile-close-btn" id="profileCloseBtn">
                <i class="fas fa-times"></i>
            </button>
        </div>
        <div class="profile-modal-content" id="profileContent">
            <!-- Profile content will be loaded here dynamically -->
        </div>
    </div>
</div>
