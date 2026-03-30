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