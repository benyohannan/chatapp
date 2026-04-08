/* 
Name                 : RainChatify – Free Unique Chat UI Template for Real-Time Messaging
Author               : TemplateRise
Url                  : https://www.templaterise.com/template/rainchatify-free-unique-chat-ui-template-for-real-time-messaging
*/

// Global variables
const welcomeScreen = document.getElementById('welcomeScreen');
const chatInterface = document.getElementById('chatInterface');
const chatMessages = document.getElementById('chatMessages');
const messageInput = document.getElementById('messageInput');
const sendBtn = document.getElementById('sendBtn');
const typingIndicator = document.getElementById('typingIndicator');
const chatName = document.getElementById('chatName');
const chatStatus = document.getElementById('chatStatus');
const chatAvatar = document.getElementById('chatAvatar');
const sidebar = document.getElementById('sidebar');
const mainChat = document.getElementById('mainChat');
const backBtn = document.getElementById('backBtn');
const themeToggle = document.getElementById('themeToggle');
const fileInput = document.getElementById('fileInput');

// Chat search elements
const chatSearchContainer = document.getElementById('chatSearchContainer');
const chatSearchInput = document.getElementById('chatSearchInput');
const searchCount = document.getElementById('searchCount');
const prevSearchBtn = document.getElementById('prevSearchBtn');
const nextSearchBtn = document.getElementById('nextSearchBtn');
const searchToggleBtn = document.getElementById('searchToggleBtn');
const closeSearchBtn = document.getElementById('closeSearchBtn');

// Context menu and reply elements
const contextMenu = document.getElementById('contextMenu');
const replyBar = document.getElementById('replyBar');
const replyBarClose = document.getElementById('replyBarClose');
const replyToName = document.getElementById('replyToName');
const replyBarContent = document.getElementById('replyBarContent');

// Chat menu elements
const chatMenuBtn = document.getElementById('chatMenuBtn');
const chatDropdownMenu = document.getElementById('chatDropdownMenu');
const clearChatBtn = document.getElementById('clearChatBtn');
const closeChatBtn = document.getElementById('closeChatBtn');

// Modal elements
const clearChatModal = document.getElementById('clearChatModal');
const closeChatModal = document.getElementById('closeChatModal');
const clearChatCancel = document.getElementById('clearChatCancel');
const clearChatConfirm = document.getElementById('clearChatConfirm');
const closeChatCancel = document.getElementById('closeChatCancel');
const closeChatConfirm = document.getElementById('closeChatConfirm');

// Profile elements
const profileModal = document.getElementById('profileModal');
const profileCloseBtn = document.getElementById('profileCloseBtn');
const profileBackBtn = document.getElementById('profileBackBtn');
const profileContent = document.getElementById('profileContent');

// User Settings Elements
const SettingControl = document.getElementById('SettingControl');
const userSettingsModal = document.getElementById('userSettingsModal');
const settingsBackBtn = document.getElementById('settingsBackBtn');
const settingsCloseBtn = document.getElementById('settingsCloseBtn');
const settingsContent = document.getElementById('settingsContent');

// Edit Profile Elements
const editProfileModal = document.getElementById('editProfileModal');
const editProfileBackBtn = document.getElementById('editProfileBackBtn');
const editProfileSaveBtn = document.getElementById('editProfileSaveBtn');
const editProfileContent = document.getElementById('editProfileContent');

// Status Elements
const StatusBtnOpen = document.getElementById('Status');
const statusModal = document.getElementById('statusModal');
const statusBackBtn = document.getElementById('statusBackBtn');
const statusCloseBtn = document.getElementById('statusCloseBtn');
const statusContent = document.getElementById('statusContent');

// Status Viewer Elements
const statusViewerModal = document.getElementById('statusViewerModal');
const statusViewerClose = document.getElementById('statusViewerClose');
const statusViewerAvatar = document.getElementById('statusViewerAvatar');
const statusViewerName = document.getElementById('statusViewerName');
const statusViewerTime = document.getElementById('statusViewerTime');
const statusViewerContent = document.getElementById('statusViewerContent');
const statusProgressBars = document.getElementById('statusProgressBars');
const prevStatusBtn = document.getElementById('prevStatusBtn');
const nextStatusBtn = document.getElementById('nextStatusBtn');
const statusReplyInput = document.getElementById('statusReplyInput');
const statusReplyBtn = document.getElementById('statusReplyBtn');

// Add Status Elements
const addStatusModal = document.getElementById('addStatusModal');
const addStatusBackBtn = document.getElementById('addStatusBackBtn');
const addStatusPostBtn = document.getElementById('addStatusPostBtn');
const statusTextArea = document.getElementById('statusTextArea');
const statusMediaInput = document.getElementById('statusMediaInput');
const textStatusInput = document.getElementById('textStatusInput');
const mediaStatusInput = document.getElementById('mediaStatusInput');
const mediaPreview = document.getElementById('mediaPreview');
const mediaPreviewContent = document.getElementById('mediaPreviewContent');
const removeMediaBtn = document.getElementById('removeMediaBtn');

// Call Elements
const callModal = document.getElementById('callModal');
const callAvatar = document.getElementById('callAvatar');
const callName = document.getElementById('callName');
const callStatus = document.getElementById('callStatus');
const callTimer = document.getElementById('callTimer');
const callVideoContainer = document.getElementById('callVideoContainer');
const localVideo = document.getElementById('localVideo');
const remoteVideo = document.getElementById('remoteVideo');
const muteBtn = document.getElementById('muteBtn');
const speakerBtn = document.getElementById('speakerBtn');
const videoBtn = document.getElementById('videoBtn');
const endCallBtn = document.getElementById('endCallBtn');
const cameraToggleBtn = document.getElementById('cameraToggleBtn');
const switchCameraBtn = document.getElementById('switchCameraBtn');

// Incoming Call Elements
const incomingCallModal = document.getElementById('incomingCallModal');
const incomingCallAvatar = document.getElementById('incomingCallAvatar');
const incomingCallName = document.getElementById('incomingCallName');
const incomingCallType = document.getElementById('incomingCallType');
const acceptCallBtn = document.getElementById('acceptCallBtn');
const declineCallBtn = document.getElementById('declineCallBtn');

// Call History Elements
const callHistoryModal = document.getElementById('callHistoryModal');
const callHistoryBackBtn = document.getElementById('callHistoryBackBtn');
const callHistoryCloseBtn = document.getElementById('callHistoryCloseBtn');
const callHistoryContent = document.getElementById('callHistoryContent');

// Global state
let searchResults = [];
let currentSearchIndex = -1;
let isSearchActive = false;
let currentTheme = 'light';
let messageIdCounter = 6;
let currentReplyingTo = null;
let selectedMessage = null;
let currentChatInfo = null;
let currentStatusUser = null;
let currentStatusIndex = 0;
let statusAutoPlay = null;
let selectedStatusType = 'text';
let selectedBackground = 'default';
let selectedMediaFile = null;

// Call state
let currentCall = null;
let localStream = null;
let remoteStream = null;
let callStartTime = null;
let callTimerInterval = null;
let isMuted = false;
let isSpeakerOn = false;
let isCameraOn = false;
let isIncomingCall = false;
let currentCallType = 'audio';

// User settings data
let userSettings = {
    profile: {
        name: 'Your Name',
        about: 'Hey there! I am using RainChatify.',
        avatar: 'ME',
        phone: '+1 (555) 123-4567'
    },
    privacy: {
        lastSeen: 'everyone',
        profilePhoto: 'everyone',
        about: 'everyone',
        status: 'contacts',
        readReceipts: true,
        groups: 'everyone'
    },
    notifications: {
        messageNotifications: true,
        groupNotifications: true,
        callNotifications: true,
        notificationSound: 'default',
        vibration: true,
        popupNotification: true
    },
    chat: {
        enterIsSend: true,
        mediaVisibility: true,
        fontSize: 'medium',
        wallpaper: 'default',
        archiveChats: false
    },
    storage: {
        autoDownloadPhotos: true,
        autoDownloadAudio: true,
        autoDownloadVideos: false,
        autoDownloadDocuments: false
    },
    security: {
        twoStepVerification: false,
        showSecurityNotifications: true,
        fingerprintLock: false
    }
};

// Status data
let statusData = {
    myStatus: [
        {
            id: 1,
            type: 'text',
            content: 'Hello World! 👋',
            background: 'default',
            timestamp: Date.now() - 3600000,
            views: 12,
            replies: []
        }
    ],
    contacts: {
        'John Doe': {
            avatar: 'JD',
            gradient: 'linear-gradient(45deg, #ff6b6b, #feca57)',
            statuses: [
                {
                    id: 1,
                    type: 'text',
                    content: 'Working on something amazing! 💻',
                    background: 'blue',
                    timestamp: Date.now() - 1800000,
                    viewed: false
                },
                {
                    id: 2,
                    type: 'photo',
                    content: 'https://picsum.photos/400/600?random=1',
                    caption: 'Beautiful sunset today! 🌅',
                    timestamp: Date.now() - 7200000,
                    viewed: false
                }
            ]
        },
        'Sarah Wilson': {
            avatar: 'SW',
            gradient: 'linear-gradient(45deg, #e74c3c, #f39c12)',
            statuses: [
                {
                    id: 1,
                    type: 'photo',
                    content: 'https://picsum.photos/400/600?random=2',
                    caption: 'Coffee and coding ☕',
                    timestamp: Date.now() - 5400000,
                    viewed: true
                }
            ]
        },
        'Mike Chen': {
            avatar: 'MC',
            gradient: 'linear-gradient(45deg, #2ecc71, #27ae60)',
            statuses: [
                {
                    id: 1,
                    type: 'text',
                    content: 'Great team meeting today! 🎉',
                    background: 'purple',
                    timestamp: Date.now() - 10800000,
                    viewed: false
                }
            ]
        },
        'Lisa Park': {
            avatar: 'LP',
            gradient: 'linear-gradient(45deg, #8e44ad, #9b59b6)',
            statuses: [
                {
                    id: 1,
                    type: 'photo',
                    content: 'https://picsum.photos/400/600?random=3',
                    caption: 'New artwork! What do you think? 🎨',
                    timestamp: Date.now() - 14400000,
                    viewed: false
                },
                {
                    id: 2,
                    type: 'text',
                    content: 'Inspiration comes from everywhere ✨',
                    background: 'pink',
                    timestamp: Date.now() - 18000000,
                    viewed: true
                }
            ]
        }
    }
};

// Call history data
let callHistory = [
    {
        id: 1,
        contact: 'John Doe',
        avatar: 'JD',
        gradient: 'linear-gradient(45deg, #ff6b6b, #feca57)',
        type: 'video',
        direction: 'outgoing',
        status: 'completed',
        duration: '12:34',
        timestamp: Date.now() - 3600000
    },
    {
        id: 2,
        contact: 'Sarah Wilson',
        avatar: 'SW',
        gradient: 'linear-gradient(45deg, #e74c3c, #f39c12)',
        type: 'audio',
        direction: 'incoming',
        status: 'missed',
        duration: null,
        timestamp: Date.now() - 7200000
    },
    {
        id: 3,
        contact: 'Mike Chen',
        avatar: 'MC',
        gradient: 'linear-gradient(45deg, #2ecc71, #27ae60)',
        type: 'audio',
        direction: 'outgoing',
        status: 'completed',
        duration: '5:42',
        timestamp: Date.now() - 14400000
    },
    {
        id: 4,
        contact: 'Lisa Park',
        avatar: 'LP',
        gradient: 'linear-gradient(45deg, #8e44ad, #9b59b6)',
        type: 'video',
        direction: 'incoming',
        status: 'declined',
        duration: null,
        timestamp: Date.now() - 21600000
    }
];

// Current chat data
let currentChatData = {
    messages: {
        'John Doe': [
            { id: 1, type: 'received', content: 'Hey! How are you doing today? 😊', time: '2:30 PM' },
            { id: 2, type: 'sent', content: "I'm doing great! Just working on some new projects. How about you?", time: '2:32 PM' },
            { id: 3, type: 'received', content: "That sounds awesome! I'd love to hear more about your projects sometime. 🚀", time: '2:33 PM' },
            { id: 4, type: 'sent', content: "Let's catch up over coffee this weekend? ☕", time: '2:35 PM' },
            { id: 5, type: 'received', content: 'Perfect! Saturday works for me. Looking forward to it! 🎉', time: '2:36 PM' }
        ],
        'Sarah Wilson': [
            { id: 6, type: 'received', content: 'Thanks for the help earlier!', time: '1:45 PM' },
            { id: 7, type: 'sent', content: 'No problem at all! Happy to help anytime.', time: '1:46 PM' },
            { id: 8, type: 'received', content: 'You are the best! 🙌', time: '1:47 PM' }
        ],
        'Team Group': [
            { id: 9, type: 'received', content: 'Mike: Let\'s schedule the meeting', time: '12:30 PM' },
            { id: 10, type: 'received', content: 'Alice: What time works for everyone?', time: '12:31 PM' },
            { id: 11, type: 'sent', content: 'I\'m free after 2 PM today', time: '12:32 PM' }
        ],
        'Alex Johnson': [
            { id: 12, type: 'sent', content: 'See you tomorrow at the conference!', time: 'Yesterday' },
            { id: 13, type: 'received', content: 'Perfect! See you tomorrow 👍', time: 'Yesterday' }
        ],
        'Emma Davis': [
            { id: 14, type: 'received', content: 'Can you send me the documents?', time: '2 days ago' },
            { id: 15, type: 'sent', content: 'Sure, I\'ll email them to you shortly.', time: '2 days ago' }
        ],
        'Family Group': [
            { id: 16, type: 'received', content: 'Mom: Don\'t forget dinner on Sunday!', time: '3 days ago' },
            { id: 17, type: 'sent', content: 'Of course! Looking forward to it 🍽️', time: '3 days ago' }
        ],
        'Mike Chen': [
            { id: 18, type: 'received', content: 'Great work on the presentation!', time: '10:15 AM' },
            { id: 19, type: 'sent', content: 'Thank you! Glad it went well.', time: '10:16 AM' }
        ],
        'Lisa Park': [
            { id: 20, type: 'received', content: 'Let\'s catch up soon! 🎨', time: '9:45 AM' },
            { id: 21, type: 'sent', content: 'Absolutely! How about this weekend?', time: '9:46 AM' }
        ]
    },
    profiles: {
        'John Doe': {
            type: 'contact',
            name: 'John Doe',
            avatar: 'JD',
            avatarGradient: 'linear-gradient(45deg, #ff6b6b, #feca57)',
            status: 'Online',
            isOnline: true,
            about: 'Entrepreneur | Coffee lover ☕ | Tech enthusiast',
            phone: '+1 (555) 123-4567'
        },
        'Sarah Wilson': {
            type: 'contact',
            name: 'Sarah Wilson',
            avatar: 'SW',
            avatarGradient: 'linear-gradient(45deg, #e74c3c, #f39c12)',
            status: 'Last seen today at 1:45 PM',
            isOnline: false,
            about: 'Designer by day, artist by night 🎨',
            phone: '+1 (555) 987-6543'
        },
        'Team Group': {
            type: 'group',
            name: 'Team Group',
            avatar: 'TG',
            avatarGradient: 'linear-gradient(45deg, #9b59b6, #3498db)',
            status: '5 members',
            memberCount: 5,
            description: 'Our awesome development team workspace. Let\'s build amazing things together! 🚀',
            members: [
                { 
                    name: 'John Doe', 
                    initials: 'JD', 
                    gradient: 'linear-gradient(45deg, #ff6b6b, #feca57)', 
                    status: 'Online', 
                    isAdmin: true 
                },
                { 
                    name: 'Sarah Wilson', 
                    initials: 'SW', 
                    gradient: 'linear-gradient(45deg, #e74c3c, #f39c12)', 
                    status: 'Last seen 2 hours ago', 
                    isAdmin: false 
                },
                { 
                    name: 'Mike Chen', 
                    initials: 'MC', 
                    gradient: 'linear-gradient(45deg, #2ecc71, #27ae60)', 
                    status: 'Online', 
                    isAdmin: false 
                },
                { 
                    name: 'Alice Johnson', 
                    initials: 'AJ', 
                    gradient: 'linear-gradient(45deg, #1abc9c, #16a085)', 
                    status: 'Last seen yesterday', 
                    isAdmin: false 
                },
                { 
                    name: 'You', 
                    initials: 'ME', 
                    gradient: 'linear-gradient(45deg, #25d366, #128c7e)', 
                    status: 'Online', 
                    isAdmin: true 
                }
            ]
        },
        'Alex Johnson': {
            type: 'contact',
            name: 'Alex Johnson',
            avatar: 'AJ',
            avatarGradient: 'linear-gradient(45deg, #1abc9c, #16a085)',
            status: 'Last seen yesterday at 11:20 PM',
            isOnline: false,
            about: 'Travel blogger | Nature lover 🌲',
            phone: '+1 (555) 456-7890'
        },
        'Emma Davis': {
            type: 'contact',
            name: 'Emma Davis',
            avatar: 'ED',
            avatarGradient: 'linear-gradient(45deg, #f1c40f, #f39c12)',
            status: 'Last seen 2 days ago',
            isOnline: false,
            about: 'Marketing specialist | Yoga enthusiast 🧘‍♀️',
            phone: '+1 (555) 234-5678'
        },
        'Family Group': {
            type: 'group',
            name: 'Family Group',
            avatar: 'FG',
            avatarGradient: 'linear-gradient(45deg, #e67e22, #d35400)',
            status: '8 members',
            memberCount: 8,
            description: 'Our loving family group ❤️ Stay connected and share precious moments!',
            members: [
                { 
                    name: 'Mom', 
                    initials: 'M', 
                    gradient: 'linear-gradient(45deg, #e74c3c, #c0392b)', 
                    status: 'Online', 
                    isAdmin: true 
                },
                { 
                    name: 'Dad', 
                    initials: 'D', 
                    gradient: 'linear-gradient(45deg, #3498db, #2980b9)', 
                    status: 'Last seen 1 hour ago', 
                    isAdmin: true 
                },
                { 
                    name: 'Sister', 
                    initials: 'S', 
                    gradient: 'linear-gradient(45deg, #9b59b6, #8e44ad)', 
                    status: 'Online', 
                    isAdmin: false 
                },
                { 
                    name: 'Brother', 
                    initials: 'B', 
                    gradient: 'linear-gradient(45deg, #f39c12, #e67e22)', 
                    status: 'Last seen 30 minutes ago', 
                    isAdmin: false 
                },
                { 
                    name: 'You', 
                    initials: 'ME', 
                    gradient: 'linear-gradient(45deg, #25d366, #128c7e)', 
                    status: 'Online', 
                    isAdmin: false 
                }
            ]
        },
        'Mike Chen': {
            type: 'contact',
            name: 'Mike Chen',
            avatar: 'MC',
            avatarGradient: 'linear-gradient(45deg, #2ecc71, #27ae60)',
            status: 'Last seen 5 hours ago',
            isOnline: false,
            about: 'Software developer | Gamer 🎮',
            phone: '+1 (555) 345-6789'
        },
        'Lisa Park': {
            type: 'contact',
            name: 'Lisa Park',
            avatar: 'LP',
            avatarGradient: 'linear-gradient(45deg, #8e44ad, #9b59b6)',
            status: 'Online',
            isOnline: true,
            about: 'Graphic designer | Creative soul ✨',
            phone: '+1 (555) 567-8901'
        }
    }
};

// Mobile detection
function isMobileDevice() {
    return window.innerWidth <= 768 || 
           /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent);
}

// Load settings from localStorage
function loadUserSettings() {
    const saved = localStorage.getItem('RainChatify-user-settings');
    if (saved) {
        userSettings = { ...userSettings, ...JSON.parse(saved) };
    }
    
    const savedStatus = localStorage.getItem('RainChatify-status-data');
    if (savedStatus) {
        statusData = { ...statusData, ...JSON.parse(savedStatus) };
    }

    const savedCallHistory = localStorage.getItem('RainChatify-call-history');
    if (savedCallHistory) {
        callHistory = [...JSON.parse(savedCallHistory)];
    }
}

// Save settings to localStorage
function saveUserSettings() {
    localStorage.setItem('RainChatify-user-settings', JSON.stringify(userSettings));
}

// Save status data
function saveStatusData() {
    localStorage.setItem('RainChatify-status-data', JSON.stringify(statusData));
}

// Save call history
function saveCallHistory() {
    localStorage.setItem('RainChatify-call-history', JSON.stringify(callHistory));
}

// CALL FUNCTIONS

// Start audio call
function startAudioCall(contactName) {
    if (!contactName && currentChatInfo) {
        contactName = currentChatInfo.name;
    }
    
    currentCallType = 'audio';
    initiateCall(contactName, 'audio');
}

// Start video call
function startVideoCall(contactName) {
    if (!contactName && currentChatInfo) {
        contactName = currentChatInfo.name;
    }
    
    currentCallType = 'video';
    initiateCall(contactName, 'video');
}

// Initiate call
async function initiateCall(contactName, type) {
    try {
        const profile = currentChatData.profiles[contactName];
        if (!profile) return;

        currentCall = {
            contact: contactName,
            type: type,
            direction: 'outgoing',
            status: 'calling'
        };

        // Show call interface
        showModal(callModal);
        setupCallInterface(profile, type);
        
        // Request media permissions
        if (type === 'video') {
            localStream = await navigator.mediaDevices.getUserMedia({ 
                video: true, 
                audio: true 
            });
            localVideo.srcObject = localStream;
            callVideoContainer.style.display = 'block';
            videoBtn.style.display = 'inline-block';
            isCameraOn = true;
        } else {
            localStream = await navigator.mediaDevices.getUserMedia({ 
                video: false, 
                audio: true 
            });
            callVideoContainer.style.display = 'none';
            videoBtn.style.display = 'none';
        }

        // Simulate call connection after 3 seconds
        setTimeout(() => {
            if (currentCall && currentCall.status === 'calling') {
                connectCall();
            }
        }, 3000);

        // Add to call history
        addToCallHistory(contactName, type, 'outgoing', 'completed');

        showNotification(`${type === 'video' ? 'Video' : 'Audio'} calling ${contactName}...`);
        
    } catch (error) {
        console.error('Error starting call:', error);
        showNotification('Unable to access camera/microphone');
        endCall();
    }
}

// Setup call interface
function setupCallInterface(profile, type) {
    callAvatar.style.background = profile.avatarGradient;
    callAvatar.textContent = profile.avatar;
    callName.textContent = profile.name;
    callStatus.textContent = 'Calling...';
    callTimer.style.display = 'none';
    
    // Reset button states
    isMuted = false;
    isSpeakerOn = false;
    updateCallButtons();
}

// Connect call
function connectCall() {
    if (!currentCall) return;
    
    currentCall.status = 'connected';
    callStatus.textContent = 'Connected';
    callStartTime = Date.now();
    
    // Start call timer
    callTimer.style.display = 'block';
    startCallTimer();
    
    if (currentCallType === 'video') {
        simulateRemoteVideo();
    }
    
    showNotification('Call connected');
}

// Start call timer
function startCallTimer() {
    callTimerInterval = setInterval(() => {
        if (!callStartTime) return;
        
        const elapsed = Date.now() - callStartTime;
        const minutes = Math.floor(elapsed / 60000);
        const seconds = Math.floor((elapsed % 60000) / 1000);
        
        callTimer.textContent = `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
    }, 1000);
}

// End call
function endCall() {
    if (currentCall) {
        const duration = callStartTime ? formatCallDuration(Date.now() - callStartTime) : null;
        
        // Update call history with actual duration
        if (duration && callHistory.length > 0) {
            const lastCall = callHistory[0];
            if (lastCall.contact === currentCall.contact && lastCall.status === 'completed') {
                lastCall.duration = duration;
                saveCallHistory();
            }
        }
    }
    
    // Stop media streams
    if (localStream) {
        localStream.getTracks().forEach(track => track.stop());
        localStream = null;
    }
    
    if (remoteStream) {
        remoteStream.getTracks().forEach(track => track.stop());
        remoteStream = null;
    }
    
    // Clear timers
    if (callTimerInterval) {
        clearInterval(callTimerInterval);
        callTimerInterval = null;
    }
    
    // Reset state
    currentCall = null;
    callStartTime = null;
    isMuted = false;
    isSpeakerOn = false;
    isCameraOn = false;
    
    // Hide call interface
    hideModal(callModal);
    hideModal(incomingCallModal);
    
    showNotification('Call ended');
}

// Toggle mute
function toggleMute() {
    if (!localStream) return;
    
    isMuted = !isMuted;
    localStream.getAudioTracks().forEach(track => {
        track.enabled = !isMuted;
    });
    
    updateCallButtons();
    showNotification(isMuted ? 'Microphone muted' : 'Microphone unmuted');
}

// Toggle speaker
function toggleSpeaker() {
    isSpeakerOn = !isSpeakerOn;
    updateCallButtons();
    showNotification(isSpeakerOn ? 'Speaker on' : 'Speaker off');
}

// Toggle video
function toggleVideo() {
    if (!localStream) return;
    
    isCameraOn = !isCameraOn;
    localStream.getVideoTracks().forEach(track => {
        track.enabled = isCameraOn;
    });
    
    if (isCameraOn) {
        callVideoContainer.style.display = 'block';
    } else {
        callVideoContainer.style.display = 'none';
    }
    
    updateCallButtons();
    showNotification(isCameraOn ? 'Camera on' : 'Camera off');
}

// Switch camera (front/back)
async function switchCamera() {
    if (!localStream || !isCameraOn) return;
    
    try {
        const videoTrack = localStream.getVideoTracks()[0];
        const constraints = videoTrack.getConstraints();
        
        // Toggle facingMode
        const currentFacingMode = constraints.facingMode || 'user';
        const newFacingMode = currentFacingMode === 'user' ? 'environment' : 'user';
        
        const newStream = await navigator.mediaDevices.getUserMedia({
            video: { facingMode: newFacingMode },
            audio: true
        });
        
        // Replace video track
        videoTrack.stop();
        localVideo.srcObject = newStream;
        localStream = newStream;
        
        showNotification('Camera switched');
    } catch (error) {
        console.error('Error switching camera:', error);
        showNotification('Unable to switch camera');
    }
}

// Update call button states
function updateCallButtons() {
    // Mute button
    muteBtn.classList.toggle('active', isMuted);
    muteBtn.querySelector('i').className = isMuted ? 'fas fa-microphone-slash' : 'fas fa-microphone';
    muteBtn.title = isMuted ? 'Unmute' : 'Mute';
    
    // Speaker button
    speakerBtn.classList.toggle('active', isSpeakerOn);
    speakerBtn.title = isSpeakerOn ? 'Turn off speaker' : 'Turn on speaker';
    
    // Video button
    if (videoBtn.style.display !== 'none') {
        videoBtn.classList.toggle('active', isCameraOn);
        videoBtn.querySelector('i').className = isCameraOn ? 'fas fa-video' : 'fas fa-video-slash';
        videoBtn.title = isCameraOn ? 'Turn off camera' : 'Turn on camera';
    }
    
    // Camera toggle button (in video calls)
    if (cameraToggleBtn) {
        cameraToggleBtn.classList.toggle('active', !isCameraOn);
        cameraToggleBtn.querySelector('i').className = isCameraOn ? 'fas fa-video' : 'fas fa-video-slash';
        cameraToggleBtn.title = isCameraOn ? 'Turn camera off' : 'Turn camera on';
    }
}

// Simulate incoming call
function simulateIncomingCall(contactName = 'Sarah Wilson', type = 'audio') {
    const profile = currentChatData.profiles[contactName];
    if (!profile) return;
    
    isIncomingCall = true;
    currentCall = {
        contact: contactName,
        type: type,
        direction: 'incoming',
        status: 'ringing'
    };
    
    // Setup incoming call interface
    incomingCallAvatar.style.background = profile.avatarGradient;
    incomingCallAvatar.textContent = profile.avatar;
    incomingCallName.textContent = profile.name;
    incomingCallType.textContent = `RainChatify ${type} call`;
    
    // Show incoming call modal
    showModal(incomingCallModal);
    
    // Play ringtone (simulate)
    showNotification(`Incoming ${type} call from ${contactName}`);
    
    // Auto-decline after 30 seconds
    setTimeout(() => {
        if (isIncomingCall && currentCall) {
            declineCall();
        }
    }, 30000);
}

// Accept incoming call
async function acceptCall() {
    if (!currentCall || !isIncomingCall) return;
    
    try {
        currentCallType = currentCall.type;
        
        // Hide incoming call modal
        hideModal(incomingCallModal);
        
        // Show call interface
        showModal(callModal);
        setupCallInterface(currentChatData.profiles[currentCall.contact], currentCall.type);
        
        // Request media permissions
        if (currentCall.type === 'video') {
            localStream = await navigator.mediaDevices.getUserMedia({ 
                video: true, 
                audio: true 
            });
            localVideo.srcObject = localStream;
            callVideoContainer.style.display = 'block';
            videoBtn.style.display = 'inline-block';
            isCameraOn = true;
        } else {
            localStream = await navigator.mediaDevices.getUserMedia({ 
                video: false, 
                audio: true 
            });
            callVideoContainer.style.display = 'none';
            videoBtn.style.display = 'none';
        }
        
        // Connect call immediately
        connectCall();
        
        isIncomingCall = false;
        
        // Add to call history
        addToCallHistory(currentCall.contact, currentCall.type, 'incoming', 'completed');
        
    } catch (error) {
        console.error('Error accepting call:', error);
        showNotification('Unable to access camera/microphone');
        declineCall();
    }
}

// Decline incoming call
function declineCall() {
    if (currentCall && isIncomingCall) {
        // Add to call history as missed
        addToCallHistory(currentCall.contact, currentCall.type, 'incoming', 'declined');
    }
    
    isIncomingCall = false;
    currentCall = null;
    hideModal(incomingCallModal);
    showNotification('Call declined');
}

// Simulate remote video for demo
function simulateRemoteVideo() {
    // In a real app, this would be the actual remote stream
    // For demo, we'll create a simple placeholder
    const canvas = document.createElement('canvas');
    canvas.width = 640;
    canvas.height = 480;
    const ctx = canvas.getContext('2d');
    
    // Draw a simple animation
    let frame = 0;
    const animate = () => {
        if (!currentCall || currentCall.status !== 'connected') return;
        
        ctx.fillStyle = '#2c3e50';
        ctx.fillRect(0, 0, canvas.width, canvas.height);
        
        ctx.fillStyle = '#3498db';
        ctx.font = '48px Arial';
        ctx.textAlign = 'center';
        ctx.fillText('Remote Video', canvas.width / 2, canvas.height / 2 - 20);
        
        ctx.font = '24px Arial';
        ctx.fillText(`Frame ${frame++}`, canvas.width / 2, canvas.height / 2 + 20);
        
        setTimeout(() => animate(), 100);
    };
    
    animate();
    remoteVideo.srcObject = canvas.captureStream(10);
}

// Add call to history
function addToCallHistory(contact, type, direction, status, duration = null) {
    const newCall = {
        id: Date.now(),
        contact: contact,
        avatar: currentChatData.profiles[contact].avatar,
        gradient: currentChatData.profiles[contact].avatarGradient,
        type: type,
        direction: direction,
        status: status,
        duration: duration,
        timestamp: Date.now()
    };
    
    callHistory.unshift(newCall);
    
    // Keep only last 100 calls
    if (callHistory.length > 100) {
        callHistory = callHistory.slice(0, 100);
    }
    
    saveCallHistory();
}

// Format call duration
function formatCallDuration(milliseconds) {
    const totalSeconds = Math.floor(milliseconds / 1000);
    const minutes = Math.floor(totalSeconds / 60);
    const seconds = totalSeconds % 60;
    return `${minutes}:${seconds.toString().padStart(2, '0')}`;
}

// Show call history
function showCallHistory() {
    showModal(callHistoryModal);
    loadCallHistory();
}

// Hide call history
function hideCallHistory() {
    hideModal(callHistoryModal);
}

// Load call history
function loadCallHistory() {
    const callHistoryHTML = callHistory.map(call => {
        const statusIcon = getCallStatusIcon(call);
        const timeStr = formatCallTime(call.timestamp);
        
        return `
            <div class="call-history-item">
                <div class="call-history-avatar" style="background: ${call.gradient};">
                    ${call.avatar}
                </div>
                <div class="call-history-info">
                    <div class="call-history-name">${call.contact}</div>
                    <div class="call-history-details">
                        ${statusIcon}
                        <span class="call-history-time">${timeStr}</span>
                        ${call.duration ? `<span class="call-history-duration">${call.duration}</span>` : ''}
                    </div>
                </div>
                <div class="call-history-actions">
                    <button class="call-history-action-btn" onclick="${call.type === 'video' ? 'startVideoCall' : 'startAudioCall'}('${call.contact}')" title="${call.type === 'video' ? 'Video call' : 'Audio call'}">
                        <i class="fas fa-${call.type === 'video' ? 'video' : 'phone'}"></i>
                    </button>
                </div>
            </div>
        `;
    }).join('');
    
    if (callHistory.length === 0) {
        callHistoryContent.innerHTML = `
            <div class="no-calls">
                <i class="fas fa-phone"></i>
                <h3>No calls yet</h3>
                <p>Your call history will appear here</p>
            </div>
        `;
    } else {
        callHistoryContent.innerHTML = callHistoryHTML;
    }
}

// Get call status icon
function getCallStatusIcon(call) {
    let iconClass = '';
    let iconColor = '';
    
    if (call.direction === 'outgoing') {
        iconClass = 'fas fa-arrow-up';
        iconColor = call.status === 'completed' ? '#25d366' : '#e74c3c';
    } else {
        if (call.status === 'missed' || call.status === 'declined') {
            iconClass = 'fas fa-arrow-down';
            iconColor = '#e74c3c';
        } else {
            iconClass = 'fas fa-arrow-down';
            iconColor = '#25d366';
        }
    }
    
    return `<i class="${iconClass}" style="color: ${iconColor}; margin-right: 8px;"></i>`;
}

// Format call time
function formatCallTime(timestamp) {
    const now = Date.now();
    const diff = now - timestamp;
    
    const minutes = Math.floor(diff / (1000 * 60));
    const hours = Math.floor(diff / (1000 * 60 * 60));
    const days = Math.floor(diff / (1000 * 60 * 60 * 24));
    
    if (minutes < 1) return 'Just now';
    if (minutes < 60) return `${minutes}m ago`;
    if (hours < 24) return `${hours}h ago`;
    if (days === 1) return 'Yesterday';
    if (days < 7) return `${days}d ago`;
    
    const date = new Date(timestamp);
    return date.toLocaleDateString();
}

// Theme management
function toggleTheme() {
    const body = document.body;
    const themeIcon = themeToggle.querySelector('i');
    if (currentTheme === 'light') {
        body.classList.remove('light-mode');
        themeIcon.className = 'fas fa-moon';
        currentTheme = 'dark';
        localStorage.setItem('RainChatify-theme', 'dark');
    } else {
        body.classList.add('light-mode');
        themeIcon.className = 'fas fa-sun';
        currentTheme = 'light';
        localStorage.setItem('RainChatify-theme', 'light');
    }
}

// Load saved theme
function loadTheme() {
    const savedTheme = localStorage.getItem('RainChatify-theme');
    const body = document.body;
    const themeIcon = themeToggle.querySelector('i');

    if (savedTheme === 'light') {
        body.classList.add('light-mode');
        themeIcon.className = 'fas fa-sun';
        currentTheme = 'light';
    } else {
        body.classList.remove('light-mode');
        themeIcon.className = 'fas fa-moon';
        currentTheme = 'dark';
    }
}

// Notification system
function showNotification(message, type = 'info') {
    const notification = document.createElement('div');
    notification.className = 'notification';
    notification.textContent = message;
    document.body.appendChild(notification);
    
    setTimeout(() => {
        notification.remove();
    }, 3000);
}

// Modal functions
function showModal(modalElement) {
    modalElement.classList.add('show');
    document.body.style.overflow = 'hidden';
}

function hideModal(modalElement) {
    modalElement.classList.remove('show');
    document.body.style.overflow = 'auto';
}

// STATUS FUNCTIONS

// Show status modal
function showStatusModal() {
    showModal(statusModal);
    loadStatusContent();
}

// Hide status modal
function hideStatusModal() {
    hideModal(statusModal);
}

// Load status content
function loadStatusContent() {
    const myStatusCount = statusData.myStatus.length;
    const recentStatuses = getRecentStatuses();
    const viewedStatuses = getViewedStatuses();
    
    const statusHTML = `
        <div class="status-section">
            <div class="status-section-header">
                <h3>My Status</h3>
            </div>
            <div class="my-status-item" onclick="showMyStatusOptions()">
                <div class="status-avatar-container">
                    <div class="status-avatar" style="background: linear-gradient(45deg, var(--green-primary), var(--green-secondary));">
                        ${userSettings.profile.avatar}
                    </div>
                    ${myStatusCount > 0 ? '<div class="status-ring"></div>' : ''}
                    <div class="add-status-icon">
                        <i class="fas fa-plus"></i>
                    </div>
                </div>
                <div class="status-info">
                    <div class="status-name">My Status</div>
                    <div class="status-time">
                        ${myStatusCount > 0 ? formatStatusTime(statusData.myStatus[statusData.myStatus.length - 1].timestamp) : 'Tap to add status update'}
                    </div>
                </div>
            </div>
        </div>

        ${recentStatuses.length > 0 ? `
            <div class="status-section">
                <div class="status-section-header">
                    <h3>Recent updates</h3>
                </div>
                ${recentStatuses.map(contact => `
                    <div class="status-item" onclick="viewStatus('${contact.name}', 0)">
                        <div class="status-avatar-container">
                            <div class="status-avatar" style="background: ${contact.gradient};">
                                ${contact.avatar}
                            </div>
                            <div class="status-ring ${hasUnviewedStatus(contact.name) ? 'unviewed' : 'viewed'}"></div>
                        </div>
                        <div class="status-info">
                            <div class="status-name">${contact.name}</div>
                            <div class="status-time">${formatStatusTime(contact.latestTime)}</div>
                        </div>
                        <div class="status-count">${contact.count}</div>
                    </div>
                `).join('')}
            </div>
        ` : ''}

        ${viewedStatuses.length > 0 ? `
            <div class="status-section">
                <div class="status-section-header">
                    <h3>Viewed updates</h3>
                </div>
                ${viewedStatuses.map(contact => `
                    <div class="status-item" onclick="viewStatus('${contact.name}', 0)">
                        <div class="status-avatar-container">
                            <div class="status-avatar" style="background: ${contact.gradient};">
                                ${contact.avatar}
                            </div>
                            <div class="status-ring viewed"></div>
                        </div>
                        <div class="status-info">
                            <div class="status-name">${contact.name}</div>
                            <div class="status-time">${formatStatusTime(contact.latestTime)}</div>
                        </div>
                        <div class="status-count">${contact.count}</div>
                    </div>
                `).join('')}
            </div>
        ` : ''}

        ${recentStatuses.length === 0 && viewedStatuses.length === 0 ? `
            <div class="no-status">
                <i class="fas fa-eye"></i>
                <h3>No status updates</h3>
                <p>Status updates from your contacts will appear here</p>
            </div>
        ` : ''}
    `;
    
    statusContent.innerHTML = statusHTML;
}

// Get recent statuses
function getRecentStatuses() {
    const recentStatuses = [];
    const now = Date.now();
    const dayAgo = 24 * 60 * 60 * 1000;
    
    Object.keys(statusData.contacts).forEach(contactName => {
        const contact = statusData.contacts[contactName];
        const recentContactStatuses = contact.statuses.filter(status => 
            (now - status.timestamp) < dayAgo
        );
        
        if (recentContactStatuses.length > 0 && hasUnviewedStatus(contactName)) {
            const latestStatus = recentContactStatuses.reduce((latest, current) => 
                current.timestamp > latest.timestamp ? current : latest
            );
            
            recentStatuses.push({
                name: contactName,
                avatar: contact.avatar,
                gradient: contact.gradient,
                count: recentContactStatuses.length,
                latestTime: latestStatus.timestamp
            });
        }
    });
    
    return recentStatuses.sort((a, b) => b.latestTime - a.latestTime);
}

// Get viewed statuses
function getViewedStatuses() {
    const viewedStatuses = [];
    const now = Date.now();
    const dayAgo = 24 * 60 * 60 * 1000;
    
    Object.keys(statusData.contacts).forEach(contactName => {
        const contact = statusData.contacts[contactName];
        const recentContactStatuses = contact.statuses.filter(status => 
            (now - status.timestamp) < dayAgo
        );
        
        if (recentContactStatuses.length > 0 && !hasUnviewedStatus(contactName)) {
            const latestStatus = recentContactStatuses.reduce((latest, current) => 
                current.timestamp > latest.timestamp ? current : latest
            );
            
            viewedStatuses.push({
                name: contactName,
                avatar: contact.avatar,
                gradient: contact.gradient,
                count: recentContactStatuses.length,
                latestTime: latestStatus.timestamp
            });
        }
    });
    
    return viewedStatuses.sort((a, b) => b.latestTime - a.latestTime);
}

// Check if contact has unviewed status
function hasUnviewedStatus(contactName) {
    const contact = statusData.contacts[contactName];
    if (!contact) return false;
    
    return contact.statuses.some(status => !status.viewed);
}

// Format status time
function formatStatusTime(timestamp) {
    const now = Date.now();
    const diff = now - timestamp;
    
    const minutes = Math.floor(diff / (1000 * 60));
    const hours = Math.floor(diff / (1000 * 60 * 60));
    const days = Math.floor(diff / (1000 * 60 * 60 * 24));
    
    if (minutes < 1) return 'Just now';
    if (minutes < 60) return `${minutes}m ago`;
    if (hours < 24) return `${hours}h ago`;
    return `${days}d ago`;
}

// Show my status options
function showMyStatusOptions() {
    if (statusData.myStatus.length > 0) {
        viewMyStatus();
    } else {
        showAddStatusModal();
    }
}

// View my status
function viewMyStatus() {
    showNotification('View my status - Feature coming soon!');
}

// View status
function viewStatus(contactName, startIndex = 0) {
    const contact = statusData.contacts[contactName];
    if (!contact || !contact.statuses.length) return;
    
    currentStatusUser = contactName;
    currentStatusIndex = startIndex;
    
    showModal(statusViewerModal);
    loadStatusViewer();
    startStatusAutoPlay();
}

// Load status viewer
function loadStatusViewer() {
    const contact = statusData.contacts[currentStatusUser];
    const status = contact.statuses[currentStatusIndex];
    
    statusViewerAvatar.style.background = contact.gradient;
    statusViewerAvatar.textContent = contact.avatar;
    statusViewerName.textContent = currentStatusUser;
    statusViewerTime.textContent = formatStatusTime(status.timestamp);
    
    statusProgressBars.innerHTML = contact.statuses.map((_, index) => `
        <div class="status-progress-bar ${index === currentStatusIndex ? 'active' : ''} ${index < currentStatusIndex ? 'completed' : ''}"></div>
    `).join('');
    
    if (status.type === 'text') {
        statusViewerContent.innerHTML = `
            <div class="text-status-view" style="background: ${getStatusBackground(status.background)};">
                <div class="text-status-content">${status.content}</div>
            </div>
        `;
    } else if (status.type === 'photo') {
        statusViewerContent.innerHTML = `
            <div class="photo-status-view">
                <img src="${status.content}" alt="Status" />
                ${status.caption ? `<div class="status-caption">${status.caption}</div>` : ''}
            </div>
        `;
    }
    
    if (!status.viewed) {
        status.viewed = true;
        saveStatusData();
    }
    
    prevStatusBtn.style.display = currentStatusIndex > 0 ? 'block' : 'none';
    nextStatusBtn.style.display = currentStatusIndex < contact.statuses.length - 1 ? 'block' : 'none';
}

// Get status background
function getStatusBackground(bg) {
    const backgrounds = {
        default: 'linear-gradient(45deg, #25d366, #128c7e)',
        blue: 'linear-gradient(45deg, #3498db, #2980b9)',
        purple: 'linear-gradient(45deg, #9b59b6, #8e44ad)',
        orange: 'linear-gradient(45deg, #e67e22, #d35400)',
        red: 'linear-gradient(45deg, #e74c3c, #c0392b)',
        pink: 'linear-gradient(45deg, #f39c12, #e67e22)'
    };
    return backgrounds[bg] || backgrounds.default;
}

// Start status auto play
function startStatusAutoPlay() {
    if (statusAutoPlay) {
        clearInterval(statusAutoPlay);
    }
    
    statusAutoPlay = setInterval(() => {
        navigateStatus('next');
    }, 5000);
}

// Stop status auto play
function stopStatusAutoPlay() {
    if (statusAutoPlay) {
        clearInterval(statusAutoPlay);
        statusAutoPlay = null;
    }
}

// Navigate status
function navigateStatus(direction) {
    const contact = statusData.contacts[currentStatusUser];
    
    if (direction === 'next') {
        if (currentStatusIndex < contact.statuses.length - 1) {
            currentStatusIndex++;
            loadStatusViewer();
        } else {
            const contactNames = Object.keys(statusData.contacts);
            const currentContactIndex = contactNames.indexOf(currentStatusUser);
            
            for (let i = currentContactIndex + 1; i < contactNames.length; i++) {
                const nextContact = statusData.contacts[contactNames[i]];
                if (nextContact.statuses.length > 0) {
                    currentStatusUser = contactNames[i];
                    currentStatusIndex = 0;
                    loadStatusViewer();
                    return;
                }
            }
            
            hideStatusViewer();
        }
    } else if (direction === 'prev') {
        if (currentStatusIndex > 0) {
            currentStatusIndex--;
            loadStatusViewer();
        } else {
            const contactNames = Object.keys(statusData.contacts);
            const currentContactIndex = contactNames.indexOf(currentStatusUser);
            
            for (let i = currentContactIndex - 1; i >= 0; i--) {
                const prevContact = statusData.contacts[contactNames[i]];
                if (prevContact.statuses.length > 0) {
                    currentStatusUser = contactNames[i];
                    currentStatusIndex = prevContact.statuses.length - 1;
                    loadStatusViewer();
                    return;
                }
            }
        }
    }
}

// Hide status viewer
function hideStatusViewer() {
    hideModal(statusViewerModal);
    stopStatusAutoPlay();
    loadStatusContent();
}

// Show add status modal
function showAddStatusModal() {
    showModal(addStatusModal);
    resetAddStatusForm();
}

// Hide add status modal
function hideAddStatusModal() {
    hideModal(addStatusModal);
    resetAddStatusForm();
}

// Reset add status form
function resetAddStatusForm() {
    statusTextArea.value = '';
    selectedStatusType = 'text';
    selectedBackground = 'default';
    selectedMediaFile = null;
    
    document.querySelectorAll('.status-type-btn').forEach(btn => {
        btn.classList.remove('active');
    });
    document.querySelector('[data-type="text"]').classList.add('active');
    
    document.querySelectorAll('.bg-option').forEach(opt => {
        opt.classList.remove('active');
    });
    document.querySelector('[data-bg="default"]').classList.add('active');
    
    textStatusInput.style.display = 'block';
    mediaStatusInput.style.display = 'none';
    mediaPreview.style.display = 'none';
}

// Handle status type selection
function handleStatusTypeSelection() {
    document.querySelectorAll('.status-type-btn').forEach(btn => {
        btn.addEventListener('click', () => {
            document.querySelectorAll('.status-type-btn').forEach(b => b.classList.remove('active'));
            btn.classList.add('active');
            
            selectedStatusType = btn.dataset.type;
            
            if (selectedStatusType === 'text') {
                textStatusInput.style.display = 'block';
                mediaStatusInput.style.display = 'none';
            } else {
                textStatusInput.style.display = 'none';
                mediaStatusInput.style.display = 'block';
            }
        });
    });
}

// Handle background selection
function handleBackgroundSelection() {
    document.querySelectorAll('.bg-option').forEach(option => {
        option.addEventListener('click', () => {
            document.querySelectorAll('.bg-option').forEach(opt => opt.classList.remove('active'));
            option.classList.add('active');
            selectedBackground = option.dataset.bg;
        });
    });
}

// Handle media selection
function handleMediaSelection() {
    const selectMediaBtn = document.querySelector('.select-media-btn');
    selectMediaBtn.addEventListener('click', () => {
        statusMediaInput.click();
    });
    
    statusMediaInput.addEventListener('change', (e) => {
        const file = e.target.files[0];
        if (file) {
            selectedMediaFile = file;
            showMediaPreview(file);
        }
    });
    
    removeMediaBtn.addEventListener('click', () => {
        selectedMediaFile = null;
        mediaPreview.style.display = 'none';
        statusMediaInput.value = '';
    });
}

// Show media preview
function showMediaPreview(file) {
    const reader = new FileReader();
    reader.onload = (e) => {
        if (file.type.startsWith('image/')) {
            mediaPreviewContent.innerHTML = `<img src="${e.target.result}" alt="Preview" />`;
        } else if (file.type.startsWith('video/')) {
            mediaPreviewContent.innerHTML = `<video src="${e.target.result}" controls></video>`;
        }
        mediaPreview.style.display = 'block';
    };
    reader.readAsDataURL(file);
}

// Post status
function postStatus() {
    if (selectedStatusType === 'text') {
        const text = statusTextArea.value.trim();
        if (!text) {
            showNotification('Please enter some text');
            return;
        }
        
        const newStatus = {
            id: Date.now(),
            type: 'text',
            content: text,
            background: selectedBackground,
            timestamp: Date.now(),
            views: 0,
            replies: []
        };
        
        statusData.myStatus.push(newStatus);
        saveStatusData();
        
        hideAddStatusModal();
        showNotification('Status posted successfully!');
        loadStatusContent();
        
    } else if (selectedMediaFile) {
        const reader = new FileReader();
        reader.onload = (e) => {
            const newStatus = {
                id: Date.now(),
                type: selectedStatusType === 'photo' ? 'photo' : 'video',
                content: e.target.result,
                caption: '',
                timestamp: Date.now(),
                views: 0,
                replies: []
            };
            
            statusData.myStatus.push(newStatus);
            saveStatusData();
            
            hideAddStatusModal();
            showNotification('Status posted successfully!');
            loadStatusContent();
        };
        reader.readAsDataURL(selectedMediaFile);
    } else {
        showNotification('Please select a photo or video');
    }
}

// Reply to status
function replyToStatus() {
    const reply = statusReplyInput.value.trim();
    if (!reply) return;
    
    showNotification(`Reply sent: ${reply}`);
    statusReplyInput.value = '';
}

// USER SETTINGS FUNCTIONS

// Show user settings modal
function showUserSettings() {
    showModal(userSettingsModal);
    loadSettingsContent();
}

// Hide user settings modal
function hideUserSettings() {
    hideModal(userSettingsModal);
}

// Load settings content
function loadSettingsContent() {
    const settingsHTML = `
        <div class="settings-profile-section">
            <div class="settings-profile-item" onclick="showEditProfile()">
                <div class="settings-profile-avatar">
                    <div class="settings-avatar-bg">
                        ${userSettings.profile.avatar}
                    </div>
                </div>
                <div class="settings-profile-info">
                    <div class="settings-profile-name">${userSettings.profile.name}</div>
                    <div class="settings-profile-about">${userSettings.profile.about}</div>
                </div>
                <div class="settings-profile-edit">
                    <i class="fas fa-chevron-right"></i>
                </div>
            </div>
        </div>

        <div class="settings-section">
            <div class="settings-item" onclick="showPrivacySettings()">
                <div class="settings-icon">
                    <i class="fas fa-lock"></i>
                </div>
                <div class="settings-info">
                    <div class="settings-title">Privacy</div>
                    <div class="settings-subtitle">Last seen, profile photo, about</div>
                </div>
                <div class="settings-arrow">
                    <i class="fas fa-chevron-right"></i>
                </div>
            </div>

            <div class="settings-item" onclick="showSecuritySettings()">
                <div class="settings-icon">
                    <i class="fas fa-shield-alt"></i>
                </div>
                <div class="settings-info">
                    <div class="settings-title">Security</div>
                    <div class="settings-subtitle">Two-step verification, change number</div>
                </div>
                <div class="settings-arrow">
                    <i class="fas fa-chevron-right"></i>
                </div>
            </div>

            <div class="settings-item" onclick="showNotificationSettings()">
                <div class="settings-icon">
                    <i class="fas fa-bell"></i>
                </div>
                <div class="settings-info">
                    <div class="settings-title">Notifications</div>
                    <div class="settings-subtitle">Message, group & call tones</div>
                </div>
                <div class="settings-arrow">
                    <i class="fas fa-chevron-right"></i>
                </div>
            </div>

            <div class="settings-item" onclick="showChatSettings()">
                <div class="settings-icon">
                    <i class="fas fa-comment"></i>
                </div>
                <div class="settings-info">
                    <div class="settings-title">Chats</div>
                    <div class="settings-subtitle">Theme, wallpapers, chat history</div>
                </div>
                <div class="settings-arrow">
                    <i class="fas fa-chevron-right"></i>
                </div>
            </div>

            <div class="settings-item" onclick="showStorageSettings()">
                <div class="settings-icon">
                    <i class="fas fa-database"></i>
                </div>
                <div class="settings-info">
                    <div class="settings-title">Storage and data</div>
                    <div class="settings-subtitle">Network usage, auto-download</div>
                </div>
                <div class="settings-arrow">
                    <i class="fas fa-chevron-right"></i>
                </div>
            </div>

            <div class="settings-item" onclick="showLanguageSettings()">
                <div class="settings-icon">
                    <i class="fas fa-globe"></i>
                </div>
                <div class="settings-info">
                    <div class="settings-title">Language</div>
                    <div class="settings-subtitle">English (device's language)</div>
                </div>
                <div class="settings-arrow">
                    <i class="fas fa-chevron-right"></i>
                </div>
            </div>
        </div>

        <div class="settings-section">
            <div class="settings-item" onclick="showHelpSettings()">
                <div class="settings-icon">
                    <i class="fas fa-question-circle"></i>
                </div>
                <div class="settings-info">
                    <div class="settings-title">Help</div>
                    <div class="settings-subtitle">Help center, contact us, terms and privacy policy</div>
                </div>
                <div class="settings-arrow">
                    <i class="fas fa-chevron-right"></i>
                </div>
            </div>

            <div class="settings-item" onclick="showInviteSettings()">
                <div class="settings-icon">
                    <i class="fas fa-user-plus"></i>
                </div>
                <div class="settings-info">
                    <div class="settings-title">Invite a friend</div>
                    <div class="settings-subtitle">Share RainChatify with friends</div>
                </div>
                <div class="settings-arrow">
                    <i class="fas fa-chevron-right"></i>
                </div>
            </div>
        </div>

        <div class="settings-footer">
            <div class="settings-version">RainChatify   v1.0.0</div>
        </div>
    `;
    
    settingsContent.innerHTML = settingsHTML;
}

// Show edit profile modal
function showEditProfile() {
    showModal(editProfileModal);
    loadEditProfileContent();
}

// Hide edit profile modal
function hideEditProfile() {
    hideModal(editProfileModal);
}

// Load edit profile content
function loadEditProfileContent() {
    const editProfileHTML = `
        <div class="edit-profile-section">
            <div class="edit-avatar-section">
                <div class="edit-avatar-container">
                    <div class="edit-avatar-bg">
                        ${userSettings.profile.avatar}
                    </div>
                    <div class="edit-avatar-overlay">
                        <i class="fas fa-camera"></i>
                        <span>Change photo</span>
                    </div>
                </div>
            </div>

            <div class="edit
                <div class="edit-field">
                    <label>Name</label>
                    <div class="edit-input-group">
                        <input type="text" id="editName" value="${userSettings.profile.name}" maxlength="25">
                        <span class="edit-field-icon">
                            <i class="fas fa-edit"></i>
                        </span>
                    </div>
                    <div class="edit-field-info">
                        This is not your username or pin. This name will be visible to your RainChatify contacts.
                    </div>
                </div>

                <div class="edit-field">
                    <label>About</label>
                    <div class="edit-input-group">
                        <input type="text" id="editAbout" value="${userSettings.profile.about}" maxlength="139">
                        <span class="edit-field-icon">
                            <i class="fas fa-edit"></i>
                        </span>
                    </div>
                </div>

                <div class="edit-field">
                    <label>Phone</label>
                    <div class="edit-input-group">
                        <input type="text" id="editPhone" value="${userSettings.profile.phone}" readonly>
                        <span class="edit-field-icon">
                            <i class="fas fa-lock"></i>
                        </span>
                    </div>
                    <div class="edit-field-info">
                        To change your phone number, go to Settings > Security > Change number.
                    </div>
                </div>
            </div>
        </div>
    `;
    
    editProfileContent.innerHTML = editProfileHTML;
}

// Save profile changes
function saveProfileChanges() {
    const name = document.getElementById('editName').value.trim();
    const about = document.getElementById('editAbout').value.trim();
    
    if (name) {
        userSettings.profile.name = name;
        userSettings.profile.about = about;
        
        saveUserSettings();
        hideEditProfile();
        showNotification('Profile updated successfully');
        loadSettingsContent();
    } else {
        showNotification('Name cannot be empty', 'error');
    }
}

// Show privacy settings
function showPrivacySettings() {
    const privacyHTML = `
        <div class="settings-back-header">
            <button class="settings-sub-back" onclick="loadSettingsContent()">
                <i class="fas fa-arrow-left"></i>
            </button>
            <h3>Privacy</h3>
        </div>
        
        <div class="settings-subsection">
            <div class="settings-subtitle-header">Who can see my personal info</div>
            
            <div class="privacy-setting-item">
                <div class="privacy-setting-info">
                    <div class="privacy-setting-title">Last seen</div>
                </div>
                <select class="privacy-select" onchange="updatePrivacySetting('lastSeen', this.value)">
                    <option value="everyone" ${userSettings.privacy.lastSeen === 'everyone' ? 'selected' : ''}>Everyone</option>
                    <option value="contacts" ${userSettings.privacy.lastSeen === 'contacts' ? 'selected' : ''}>My contacts</option>
                    <option value="nobody" ${userSettings.privacy.lastSeen === 'nobody' ? 'selected' : ''}>Nobody</option>
                </select>
            </div>

            <div class="privacy-setting-item">
                <div class="privacy-setting-info">
                    <div class="privacy-setting-title">Profile photo</div>
                </div>
                <select class="privacy-select" onchange="updatePrivacySetting('profilePhoto', this.value)">
                    <option value="everyone" ${userSettings.privacy.profilePhoto === 'everyone' ? 'selected' : ''}>Everyone</option>
                    <option value="contacts" ${userSettings.privacy.profilePhoto === 'contacts' ? 'selected' : ''}>My contacts</option>
                    <option value="nobody" ${userSettings.privacy.profilePhoto === 'nobody' ? 'selected' : ''}>Nobody</option>
                </select>
            </div>

            <div class="privacy-setting-item">
                <div class="privacy-setting-info">
                    <div class="privacy-setting-title">About</div>
                </div>
                <select class="privacy-select" onchange="updatePrivacySetting('about', this.value)">
                    <option value="everyone" ${userSettings.privacy.about === 'everyone' ? 'selected' : ''}>Everyone</option>
                    <option value="contacts" ${userSettings.privacy.about === 'contacts' ? 'selected' : ''}>My contacts</option>
                    <option value="nobody" ${userSettings.privacy.about === 'nobody' ? 'selected' : ''}>Nobody</option>
                </select>
            </div>

            <div class="privacy-setting-item">
                <div class="privacy-setting-info">
                    <div class="privacy-setting-title">Groups</div>
                </div>
                <select class="privacy-select" onchange="updatePrivacySetting('groups', this.value)">
                    <option value="everyone" ${userSettings.privacy.groups === 'everyone' ? 'selected' : ''}>Everyone</option>
                    <option value="contacts" ${userSettings.privacy.groups === 'contacts' ? 'selected' : ''}>My contacts</option>
                    <option value="nobody" ${userSettings.privacy.groups === 'nobody' ? 'selected' : ''}>Nobody</option>
                </select>
            </div>
        </div>

        <div class="settings-subsection">
            <div class="privacy-toggle-item">
                <div class="privacy-toggle-info">
                    <div class="privacy-toggle-title">Read receipts</div>
                    <div class="privacy-toggle-subtitle">If turned off, you won't send or receive Read receipts</div>
                </div>
                <label class="toggle-switch">
                    <input type="checkbox" ${userSettings.privacy.readReceipts ? 'checked' : ''} onchange="updatePrivacyToggle('readReceipts', this.checked)">
                    <span class="toggle-slider"></span>
                </label>
            </div>
        </div>
    `;
    
    settingsContent.innerHTML = privacyHTML;
}

// Show security settings
function showSecuritySettings() {
    const securityHTML = `
        <div class="settings-back-header">
            <button class="settings-sub-back" onclick="loadSettingsContent()">
                <i class="fas fa-arrow-left"></i>
            </button>
            <h3>Security</h3>
        </div>
        
        <div class="settings-subsection">
            <div class="security-setting-item">
                <div class="security-setting-info">
                    <div class="security-setting-title">Two-step verification</div>
                    <div class="security-setting-subtitle">${userSettings.security.twoStepVerification ? 'Enabled' : 'Disabled'}</div>
                </div>
                <div class="security-setting-action">
                    <button class="security-btn" onclick="toggleTwoStepVerification()">
                        ${userSettings.security.twoStepVerification ? 'Disable' : 'Enable'}
                    </button>
                </div>
            </div>

            <div class="security-toggle-item">
                <div class="security-toggle-info">
                    <div class="security-toggle-title">Show security notifications</div>
                    <div class="security-toggle-subtitle">Get notified when your security code changes</div>
                </div>
                <label class="toggle-switch">
                    <input type="checkbox" ${userSettings.security.showSecurityNotifications ? 'checked' : ''} onchange="updateSecurityToggle('showSecurityNotifications', this.checked)">
                    <span class="toggle-slider"></span>
                </label>
            </div>

            <div class="security-toggle-item">
                <div class="security-toggle-info">
                    <div class="security-toggle-title">Fingerprint lock</div>
                    <div class="security-toggle-subtitle">Unlock with your fingerprint</div>
                </div>
                <label class="toggle-switch">
                    <input type="checkbox" ${userSettings.security.fingerprintLock ? 'checked' : ''} onchange="updateSecurityToggle('fingerprintLock', this.checked)">
                    <span class="toggle-slider"></span>
                </label>
            </div>
        </div>
    `;
    
    settingsContent.innerHTML = securityHTML;
}

// Show notification settings
function showNotificationSettings() {
    const notificationHTML = `
        <div class="settings-back-header">
            <button class="settings-sub-back" onclick="loadSettingsContent()">
                <i class="fas fa-arrow-left"></i>
            </button>
            <h3>Notifications</h3>
        </div>
        
        <div class="settings-subsection">
            <div class="notification-toggle-item">
                <div class="notification-toggle-info">
                    <div class="notification-toggle-title">Message notifications</div>
                </div>
                <label class="toggle-switch">
                    <input type="checkbox" ${userSettings.notifications.messageNotifications ? 'checked' : ''} onchange="updateNotificationToggle('messageNotifications', this.checked)">
                    <span class="toggle-slider"></span>
                </label>
            </div>

            <div class="notification-toggle-item">
                <div class="notification-toggle-info">
                    <div class="notification-toggle-title">Group notifications</div>
                </div>
                <label class="toggle-switch">
                    <input type="checkbox" ${userSettings.notifications.groupNotifications ? 'checked' : ''} onchange="updateNotificationToggle('groupNotifications', this.checked)">
                    <span class="toggle-slider"></span>
                </label>
            </div>

            <div class="notification-toggle-item">
                <div class="notification-toggle-info">
                    <div class="notification-toggle-title">Call notifications</div>
                </div>
                <label class="toggle-switch">
                    <input type="checkbox" ${userSettings.notifications.callNotifications ? 'checked' : ''} onchange="updateNotificationToggle('callNotifications', this.checked)">
                    <span class="toggle-slider"></span>
                </label>
            </div>

            <div class="notification-toggle-item">
                <div class="notification-toggle-info">
                    <div class="notification-toggle-title">Vibration</div>
                </div>
                <label class="toggle-switch">
                    <input type="checkbox" ${userSettings.notifications.vibration ? 'checked' : ''} onchange="updateNotificationToggle('vibration', this.checked)">
                    <span class="toggle-slider"></span>
                </label>
            </div>

            <div class="notification-toggle-item">
                <div class="notification-toggle-info">
                    <div class="notification-toggle-title">Popup notification</div>
                </div>
                <label class="toggle-switch">
                    <input type="checkbox" ${userSettings.notifications.popupNotification ? 'checked' : ''} onchange="updateNotificationToggle('popupNotification', this.checked)">
                    <span class="toggle-slider"></span>
                </label>
            </div>
        </div>

        <div class="settings-subsection">
            <div class="notification-setting-item">
                <div class="notification-setting-info">
                    <div class="notification-setting-title">Notification sound</div>
                </div>
                <select class="notification-select" onchange="updateNotificationSetting('notificationSound', this.value)">
                    <option value="default" ${userSettings.notifications.notificationSound === 'default' ? 'selected' : ''}>Default</option>
                    <option value="tone1" ${userSettings.notifications.notificationSound === 'tone1' ? 'selected' : ''}>Tone 1</option>
                    <option value="tone2" ${userSettings.notifications.notificationSound === 'tone2' ? 'selected' : ''}>Tone 2</option>
                    <option value="none" ${userSettings.notifications.notificationSound === 'none' ? 'selected' : ''}>None</option>
                </select>
            </div>
        </div>
    `;
    
    settingsContent.innerHTML = notificationHTML;
}

// Show chat settings
function showChatSettings() {
    const chatHTML = `
        <div class="settings-back-header">
            <button class="settings-sub-back" onclick="loadSettingsContent()">
                <i class="fas fa-arrow-left"></i>
            </button>
            <h3>Chats</h3>
        </div>
        
        <div class="settings-subsection">
            <div class="chat-toggle-item">
                <div class="chat-toggle-info">
                    <div class="chat-toggle-title">Enter is send</div>
                    <div class="chat-toggle-subtitle">Press Enter to send messages</div>
                </div>
                <label class="toggle-switch">
                    <input type="checkbox" ${userSettings.chat.enterIsSend ? 'checked' : ''} onchange="updateChatToggle('enterIsSend', this.checked)">
                    <span class="toggle-slider"></span>
                </label>
            </div>

            <div class="chat-toggle-item">
                <div class="chat-toggle-info">
                    <div class="chat-toggle-title">Media visibility</div>
                    <div class="chat-toggle-subtitle">Show newly downloaded media in your phone's gallery</div>
                </div>
                <label class="toggle-switch">
                    <input type="checkbox" ${userSettings.chat.mediaVisibility ? 'checked' : ''} onchange="updateChatToggle('mediaVisibility', this.checked)">
                    <span class="toggle-slider"></span>
                </label>
            </div>

            <div class="chat-toggle-item">
                <div class="chat-toggle-info">
                    <div class="chat-toggle-title">Archive all chats</div>
                    <div class="chat-toggle-subtitle">Hide all chats from the main screen</div>
                </div>
                <label class="toggle-switch">
                    <input type="checkbox" ${userSettings.chat.archiveChats ? 'checked' : ''} onchange="updateChatToggle('archiveChats', this.checked)">
                    <span class="toggle-slider"></span>
                </label>
            </div>
        </div>

        <div class="settings-subsection">
            <div class="chat-setting-item">
                <div class="chat-setting-info">
                    <div class="chat-setting-title">Font size</div>
                </div>
                <select class="chat-select" onchange="updateChatSetting('fontSize', this.value)">
                    <option value="small" ${userSettings.chat.fontSize === 'small' ? 'selected' : ''}>Small</option>
                    <option value="medium" ${userSettings.chat.fontSize === 'medium' ? 'selected' : ''}>Medium</option>
                    <option value="large" ${userSettings.chat.fontSize === 'large' ? 'selected' : ''}>Large</option>
                </select>
            </div>

            <div class="chat-setting-item">
                <div class="chat-setting-info">
                    <div class="chat-setting-title">Wallpaper</div>
                </div>
                <select class="chat-select" onchange="updateChatSetting('wallpaper', this.value)">
                    <option value="default" ${userSettings.chat.wallpaper === 'default' ? 'selected' : ''}>Default</option>
                    <option value="none" ${userSettings.chat.wallpaper === 'none' ? 'selected' : ''}>None</option>
                    <option value="custom" ${userSettings.chat.wallpaper === 'custom' ? 'selected' : ''}>Custom</option>
                </select>
            </div>
        </div>
    `;
    
    settingsContent.innerHTML = chatHTML;
}

// Show storage settings
function showStorageSettings() {
    const storageHTML = `
        <div class="settings-back-header">
            <button class="settings-sub-back" onclick="loadSettingsContent()">
                <i class="fas fa-arrow-left"></i>
            </button>
            <h3>Storage and data</h3>
        </div>
        
        <div class="settings-subsection">
            <div class="settings-subtitle-header">Auto-download media</div>
            
            <div class="storage-toggle-item">
                <div class="storage-toggle-info">
                    <div class="storage-toggle-title">Photos</div>
                </div>
                <label class="toggle-switch">
                    <input type="checkbox" ${userSettings.storage.autoDownloadPhotos ? 'checked' : ''} onchange="updateStorageToggle('autoDownloadPhotos', this.checked)">
                    <span class="toggle-slider"></span>
                </label>
            </div>

            <div class="storage-toggle-item">
                <div class="storage-toggle-info">
                    <div class="storage-toggle-title">Audio</div>
                </div>
                <label class="toggle-switch">
                    <input type="checkbox" ${userSettings.storage.autoDownloadAudio ? 'checked' : ''} onchange="updateStorageToggle('autoDownloadAudio', this.checked)">
                    <span class="toggle-slider"></span>
                </label>
            </div>

            <div class="storage-toggle-item">
                <div class="storage-toggle-info">
                    <div class="storage-toggle-title">Videos</div>
                </div>
                <label class="toggle-switch">
                    <input type="checkbox" ${userSettings.storage.autoDownloadVideos ? 'checked' : ''} onchange="updateStorageToggle('autoDownloadVideos', this.checked)">
                    <span class="toggle-slider"></span>
                </label>
            </div>

            <div class="storage-toggle-item">
                <div class="storage-toggle-info">
                    <div class="storage-toggle-title">Documents</div>
                </div>
                <label class="toggle-switch">
                    <input type="checkbox" ${userSettings.storage.autoDownloadDocuments ? 'checked' : ''} onchange="updateStorageToggle('autoDownloadDocuments', this.checked)">
                    <span class="toggle-slider"></span>
                </label>
            </div>
        </div>

        <div class="settings-subsection">
            <div class="storage-info-item">
                <div class="storage-info-title">Storage usage</div>
                <div class="storage-info-value">1.2 GB</div>
            </div>
            <div class="storage-action-item" onclick="manageStorage()">
                <div class="storage-action-title">Manage storage</div>
                <i class="fas fa-chevron-right"></i>
            </div>
        </div>
    `;
    
    settingsContent.innerHTML = storageHTML;
}

// Update setting functions
function updatePrivacySetting(setting, value) {
    userSettings.privacy[setting] = value;
    saveUserSettings();
    showNotification(`Privacy setting updated: ${setting}`);
}

function updatePrivacyToggle(setting, checked) {
    userSettings.privacy[setting] = checked;
    saveUserSettings();
    showNotification(`Privacy setting ${checked ? 'enabled' : 'disabled'}: ${setting}`);
}

function updateSecurityToggle(setting, checked) {
    userSettings.security[setting] = checked;
    saveUserSettings();
    showNotification(`Security setting ${checked ? 'enabled' : 'disabled'}: ${setting}`);
}

function updateNotificationToggle(setting, checked) {
    userSettings.notifications[setting] = checked;
    saveUserSettings();
    showNotification(`Notification setting ${checked ? 'enabled' : 'disabled'}: ${setting}`);
}

function updateNotificationSetting(setting, value) {
    userSettings.notifications[setting] = value;
    saveUserSettings();
    showNotification(`Notification setting updated: ${setting}`);
}

function updateChatToggle(setting, checked) {
    userSettings.chat[setting] = checked;
    saveUserSettings();
    
    if (setting === 'fontSize') {
        applyChatFontSize(userSettings.chat.fontSize);
    }
    
    showNotification(`Chat setting ${checked ? 'enabled' : 'disabled'}: ${setting}`);
}

function updateChatSetting(setting, value) {
    userSettings.chat[setting] = value;
    saveUserSettings();
    
    if (setting === 'fontSize') {
        applyChatFontSize(value);
    }
    
    showNotification(`Chat setting updated: ${setting}`);
}

function updateStorageToggle(setting, checked) {
    userSettings.storage[setting] = checked;
    saveUserSettings();
    showNotification(`Storage setting ${checked ? 'enabled' : 'disabled'}: ${setting}`);
}

// Apply chat font size
function applyChatFontSize(size) {
    const root = document.documentElement;
    switch (size) {
        case 'small':
            root.style.setProperty('--message-font-size', '13px');
            break;
        case 'medium':
            root.style.setProperty('--message-font-size', '15px');
            break;
        case 'large':
            root.style.setProperty('--message-font-size', '17px');
            break;
    }
}

// Toggle two-step verification
function toggleTwoStepVerification() {
    userSettings.security.twoStepVerification = !userSettings.security.twoStepVerification;
    saveUserSettings();
    showSecuritySettings();
    showNotification(`Two-step verification ${userSettings.security.twoStepVerification ? 'enabled' : 'disabled'}`);
}

// Show placeholder functions for other settings
function showLanguageSettings() {
    showNotification('Language settings - Coming soon!');
}

function showHelpSettings() {
    showNotification('Help center - Coming soon!');
}

function showInviteSettings() {
    showNotification('Invite friends - Coming soon!');
}

function manageStorage() {
    showNotification('Storage management - Coming soon!');
}

// PROFILE MODAL FUNCTIONS

// Profile modal functions
function showProfileModal() {
    showModal(profileModal);
    loadProfileContent();
}

function hideProfileModal() {
    hideModal(profileModal);
}

function loadProfileContent() {
    if (!currentChatInfo) return;
    
    const isGroup = currentChatInfo.type === 'group';
    const attachments = getAttachmentsForChat(currentChatInfo.name);
    
    let profileHTML = '';
    
    if (isGroup) {
        profileHTML = `
            <div class="profile-header">
                <div class="profile-avatar-large">
                    <div class="profile-avatar-bg" style="background: ${currentChatInfo.avatarGradient};">
                        ${currentChatInfo.avatar}
                    </div>
                </div>
                <h2 class="profile-name">${currentChatInfo.name}</h2>
                <p class="profile-status">Group • ${currentChatInfo.memberCount} members</p>
            </div>
            
            <div class="profile-section">
                <div class="profile-section-header">
                    <h3>Group Description</h3>
                </div>
                <div class="profile-section-content">
                    <p>${currentChatInfo.description || 'No description available'}</p>
                </div>
            </div>
            
            <div class="profile-section">
                <div class="profile-section-header">
                    <h3>Members (${currentChatInfo.members.length})</h3>
                </div>
                <div class="profile-section-content">
                    ${currentChatInfo.members.map(member => `
                        <div class="member-item">
                            <div class="member-avatar" style="background: ${member.gradient};">
                                ${member.initials}
                            </div>
                            <div class="member-info">
                                <div class="member-name">${member.name}</div>
                                <div class="member-status">${member.status}</div>
                                ${member.isAdmin ? '<span class="admin-badge">Admin</span>' : ''}
                            </div>
                            <div class="member-actions">
                                <i class="fas fa-ellipsis-v"></i>
                            </div>
                        </div>
                    `).join('')}
                </div>
            </div>
            
            <div class="profile-section">
                <div class="profile-section-header">
                    <h3>Media, Links and Docs</h3>
                    <span class="attachment-count">${attachments.length}</span>
                </div>
                <div class="profile-section-content">
                    ${attachments.length > 0 ? `
                        <div class="attachment-grid">
                            ${attachments.slice(0, 6).map(attachment => `
                                <div class="attachment-item" data-type="${attachment.type}">
                                    ${attachment.type === 'image' ? `
                                        <img src="${attachment.url}" alt="${attachment.name}" />
                                    ` : `
                                        <div class="file-preview">
                                            <i class="${getFileIcon(attachment.type)}"></i>
                                            <span class="file-name">${attachment.name}</span>
                                        </div>
                                    `}
                                </div>
                            `).join('')}
                        </div>
                        ${attachments.length > 6 ? `
                            <div class="view-all-attachments">
                                <span>View all ${attachments.length} attachments</span>
                                <i class="fas fa-chevron-right"></i>
                            </div>
                        ` : ''}
                    ` : `
                        <div class="no-attachments">
                            <i class="fas fa-paperclip"></i>
                            <p>No attachments yet</p>
                        </div>
                    `}
                </div>
            </div>
            
            <div class="profile-section">
                <div class="profile-section-header">
                    <h3>Group Actions</h3>
                </div>
                <div class="profile-section-content">
                    <div class="profile-action-item">
                        <i class="fas fa-user-plus"></i>
                        <span>Add member</span>
                    </div>
                    <div class="profile-action-item">
                        <i class="fas fa-edit"></i>
                        <span>Edit group info</span>
                    </div>
                    <div class="profile-action-item danger">
                        <i class="fas fa-sign-out-alt"></i>
                        <span>Exit group</span>
                    </div>
                </div>
            </div>
        `;
    } else {
        profileHTML = `
            <div class="profile-header">
                <div class="profile-avatar-large">
                    <div class="profile-avatar-bg" style="background: ${currentChatInfo.avatarGradient};">
                        ${currentChatInfo.avatar}
                    </div>
                    ${currentChatInfo.isOnline ? '<div class="online-indicator-large"></div>' : ''}
                </div>
                <h2 class="profile-name">${currentChatInfo.name}</h2>
                <p class="profile-status">${currentChatInfo.status}</p>
            </div>
            
            <div class="profile-section">
                <div class="profile-section-header">
                    <h3>About</h3>
                </div>
                <div class="profile-section-content">
                    <p>${currentChatInfo.about || 'Hey there! I am using RainChatify.'}</p>
                    <span class="about-time">Today at 3:15 PM</span>
                </div>
            </div>
            
            <div class="profile-section">
                <div class="profile-section-header">
                    <h3>Phone</h3>
                </div>
                <div class="profile-section-content">
                    <p>${currentChatInfo.phone || '+1 234 567 8900'}</p>
                </div>
            </div>
            
            <div class="profile-section">
                <div class="profile-section-header">
                    <h3>Media, Links and Docs</h3>
                    <span class="attachment-count">${attachments.length}</span>
                </div>
                <div class="profile-section-content">
                    ${attachments.length > 0 ? `
                        <div class="attachment-grid">
                            ${attachments.slice(0, 6).map(attachment => `
                                <div class="attachment-item" data-type="${attachment.type}" onclick="openAttachment('${attachment.url}', '${attachment.type}')">
                                    ${attachment.type === 'image' ? `
                                        <img src="${attachment.url}" alt="${attachment.name}" />
                                    ` : `
                                        <div class="file-preview">
                                            <i class="${getFileIcon(attachment.type)}"></i>
                                            <span class="file-name">${attachment.name}</span>
                                        </div>
                                    `}
                                </div>
                            `).join('')}
                        </div>
                        ${attachments.length > 6 ? `
                            <div class="view-all-attachments" onclick="showAllAttachments()">
                                <span>View all ${attachments.length} attachments</span>
                                <i class="fas fa-chevron-right"></i>
                            </div>
                        ` : ''}
                    ` : `
                        <div class="no-attachments">
                            <i class="fas fa-paperclip"></i>
                            <p>No attachments yet</p>
                        </div>
                    `}
                </div>
            </div>
            
            <div class="profile-section">
                <div class="profile-section-header">
                    <h3>Actions</h3>
                </div>
                <div class="profile-section-content">
                    <div class="profile-action-item" onclick="startAudioCall('${currentChatInfo.name}')">
                        <i class="fas fa-phone"></i>
                        <span>Audio call</span>
                    </div>
                    <div class="profile-action-item" onclick="startVideoCall('${currentChatInfo.name}')">
                        <i class="fas fa-video"></i>
                        <span>Video call</span>
                    </div>
                    <div class="profile-action-item">
                        <i class="fas fa-bell-slash"></i>
                        <span>Mute notifications</span>
                    </div>
                    <div class="profile-action-item">
                        <i class="fas fa-image"></i>
                        <span>Custom wallpaper</span>
                    </div>
                    <div class="profile-action-item danger">
                        <i class="fas fa-trash"></i>
                        <span>Delete chat</span>
                    </div>
                    <div class="profile-action-item danger">
                        <i class="fas fa-ban"></i>
                        <span>Block contact</span>
                    </div>
                </div>
            </div>
        `;
    }
    
    profileContent.innerHTML = profileHTML;
}

function openAttachment(url, type) {
    const viewer = document.createElement('div');
    viewer.className = 'attachment-viewer-modal';
    viewer.innerHTML = `
        <div class="attachment-viewer-overlay">
            <div class="attachment-viewer-content">
                <div class="attachment-viewer-header">
                    <button class="attachment-viewer-close">
                        <i class="fas fa-times"></i>
                    </button>
                </div>
                <div class="attachment-viewer-body">
                    ${type === 'image' ? `
                        <img src="${url}" alt="Attachment" />
                    ` : `
                        <div class="file-viewer">
                            <i class="${getFileIcon(type)}"></i>
                            <p>File cannot be previewed</p>
                            <button class="download-btn">Download</button>
                        </div>
                    `}
                </div>
            </div>
        </div>
    `;
    
    document.body.appendChild(viewer);
    
    viewer.querySelector('.attachment-viewer-close').addEventListener('click', () => {
        viewer.remove();
    });
    
    viewer.addEventListener('click', (e) => {
        if (e.target === viewer) {
            viewer.remove();
        }
    });
}

function showAllAttachments() {
    const attachments = getAttachmentsForChat(currentChatInfo.name);
    
    const viewer = document.createElement('div');
    viewer.className = 'all-attachments-modal';
    viewer.innerHTML = `
        <div class="attachment-viewer-overlay">
            <div class="attachment-viewer-content">
                <div class="attachment-viewer-header">
                    <h3>All Attachments (${attachments.length})</h3>
                    <button class="attachment-viewer-close">
                        <i class="fas fa-times"></i>
                    </button>
                </div>
                <div class="attachment-tabs">
                    <button class="tab-btn active" data-tab="all">All</button>
                    <button class="tab-btn" data-tab="images">Photos</button>
                    <button class="tab-btn" data-tab="documents">Documents</button>
                </div>
                <div class="attachment-viewer-body">
                    <div class="attachment-grid-large">
                        ${attachments.map(attachment => `
                            <div class="attachment-item-large" data-type="${attachment.type}" onclick="openAttachment('${attachment.url}', '${attachment.type}')">
                                ${attachment.type === 'image' ? `
                                    <img src="${attachment.url}" alt="${attachment.name}" />
                                ` : `
                                    <div class="file-preview-large">
                                        <i class="${getFileIcon(attachment.type)}"></i>
                                        <span class="file-name">${attachment.name}</span>
                                        <span class="file-date">${attachment.date}</span>
                                    </div>
                                `}
                            </div>
                        `).join('')}
                    </div>
                </div>
            </div>
        </div>
    `;
    
    document.body.appendChild(viewer);
    
    viewer.querySelectorAll('.tab-btn').forEach(tab => {
        tab.addEventListener('click', () => {
            viewer.querySelectorAll('.tab-btn').forEach(t => t.classList.remove('active'));
            tab.classList.add('active');
            
            const tabType = tab.dataset.tab;
            const items = viewer.querySelectorAll('.attachment-item-large');
            
            items.forEach(item => {
                const itemType = item.dataset.type;
                if (tabType === 'all' || 
                    (tabType === 'images' && itemType === 'image') ||
                    (tabType === 'documents' && itemType !== 'image')) {
                    item.style.display = 'block';
                } else {
                    item.style.display = 'none';
                }
            });
        });
    });
    
    viewer.querySelector('.attachment-viewer-close').addEventListener('click', () => {
        viewer.remove();
    });
    
    viewer.addEventListener('click', (e) => {
        if (e.target === viewer) {
            viewer.remove();
        }
    });
}



function getAttachmentsForChat(chatName) {
    const attachmentsData = {
        'John Doe': [
            { name: 'vacation.jpg', type: 'image', url: 'https://picsum.photos/300/200?random=1', date: '2 days ago' },
            { name: 'document.pdf', type: 'pdf', url: '#', date: '1 week ago' },
            { name: 'presentation.pptx', type: 'powerpoint', url: '#', date: '2 weeks ago' },
            { name: 'screenshot.png', type: 'image', url: 'https://picsum.photos/300/200?random=2', date: '3 weeks ago' },
            { name: 'spreadsheet.xlsx', type: 'excel', url: '#', date: '1 month ago' },
            { name: 'profile.jpg', type: 'image', url: 'https://picsum.photos/300/200?random=3', date: '1 month ago' },
            { name: 'report.docx', type: 'word', url: '#', date: '2 months ago' }
        ],
        'Sarah Wilson': [
            { name: 'design.jpg', type: 'image', url: 'https://picsum.photos/300/200?random=4', date: '1 day ago' },
            { name: 'project.zip', type: 'archive', url: '#', date: '3 days ago' },
            { name: 'music.mp3', type: 'audio', url: '#', date: '1 week ago' }
        ],
        'Team Group': [
            { name: 'meeting.jpg', type: 'image', url: 'https://picsum.photos/300/200?random=5', date: '1 hour ago' },
            { name: 'agenda.pdf', type: 'pdf', url: '#', date: '2 hours ago' },
            { name: 'budget.xlsx', type: 'excel', url: '#', date: '1 day ago' },
            { name: 'timeline.png', type: 'image', url: 'https://picsum.photos/300/200?random=6', date: '2 days ago' },
            { name: 'proposal.docx', type: 'word', url: '#', date: '3 days ago' }
        ]
    };
    
    return attachmentsData[chatName] || [];
}

// CHAT MENU FUNCTIONS

// Chat menu functions
function toggleChatMenu() {
    const isVisible = chatDropdownMenu.classList.contains('show');
    
    if (isVisible) {
        chatDropdownMenu.classList.remove('show');
    } else {
        const rect = chatMenuBtn.getBoundingClientRect();
        chatDropdownMenu.style.right = '20px';
        chatDropdownMenu.style.top = (rect.bottom + 5) + 'px';
        chatDropdownMenu.classList.add('show');
    }
}

function clearChat() {
    showModal(clearChatModal);
}

function confirmClearChat() {
    const messages = chatMessages.querySelectorAll('.message');
    messages.forEach((message, index) => {
        setTimeout(() => {
            message.style.animation = 'messageSlide 0.3s ease-out reverse';
            setTimeout(() => {
                message.remove();
            }, 300);
        }, index * 50);
    });

    const currentChatName = chatName.textContent;
    if (currentChatData.messages[currentChatName]) {
        currentChatData.messages[currentChatName] = [];
    }

    setTimeout(() => {
        if (chatMessages.querySelectorAll('.message').length === 0) {
            showEmptyChatState();
        }
    }, messages.length * 50 + 500);

    hideModal(clearChatModal);
    showNotification('Chat cleared successfully');
}

function showEmptyChatState() {
    const emptyState = document.createElement('div');
    emptyState.className = 'empty-chat';
    emptyState.innerHTML = `
        <i class="fas fa-comments"></i>
        <div class="empty-chat-title">No messages yet</div>
        <div class="empty-chat-subtitle">Start a conversation by sending a message below</div>
    `;
    chatMessages.insertBefore(emptyState, typingIndicator);
}

function closeChat() {
    showModal(closeChatModal);
}

function confirmCloseChat() {
    closeChatSearch();
    closeReplyBar();
    
    chatInterface.style.display = 'none';
    welcomeScreen.style.display = 'flex';
    
    document.querySelectorAll('.chat-item').forEach(item => {
        item.classList.remove('active');
    });

    if (isMobileDevice()) {
        sidebar.classList.remove('hide');
        mainChat.classList.remove('show');
    }

    hideModal(closeChatModal);
    showNotification('Chat closed');
}


// Call modal close/hide functions
function hideCallModal() {
    hideModal(callModal);
    endCall();
}

function hideIncomingCallModal() {
    hideModal(incomingCallModal);
    declineCall();
}

function hideCallHistoryModal() {
    hideModal(callHistoryModal);
}

// Updated end call function
function endCall() {
    if (currentCall) {
        const duration = callStartTime ? formatCallDuration(Date.now() - callStartTime) : null;
        
        // Update call history with actual duration
        if (duration && callHistory.length > 0) {
            const lastCall = callHistory[0];
            if (lastCall.contact === currentCall.contact && lastCall.status === 'completed') {
                lastCall.duration = duration;
                saveCallHistory();
            }
        }
    }
    
    // Stop media streams
    if (localStream) {
        localStream.getTracks().forEach(track => track.stop());
        localStream = null;
    }
    
    if (remoteStream) {
        remoteStream.getTracks().forEach(track => track.stop());
        remoteStream = null;
    }
    
    // Clear timers
    if (callTimerInterval) {
        clearInterval(callTimerInterval);
        callTimerInterval = null;
    }
    
    // Reset state
    currentCall = null;
    callStartTime = null;
    isMuted = false;
    isSpeakerOn = false;
    isCameraOn = false;
    
    // Hide call interface
    hideModal(callModal);
    hideModal(incomingCallModal);
    
    showNotification('Call ended');
}

// MESSAGING FUNCTIONS

// Initialize event listeners
function initializeEventListeners() {
    // Theme toggle
    themeToggle.addEventListener('click', toggleTheme);

    // Status icon click in sidebar
    // const statusIcon = document.querySelector('.fa-circle-notch');
    if (StatusBtnOpen) {
        StatusBtnOpen.addEventListener('click', showStatusModal);
    }

    // Status modal close buttons
    if (statusBackBtn) {
        statusBackBtn.addEventListener('click', hideStatusModal);
    }
    if (statusCloseBtn) {
        statusCloseBtn.addEventListener('click', hideStatusModal);
    }
    if (statusModal) {
        statusModal.addEventListener('click', function(e) {
            if (e.target === statusModal) {
                hideStatusModal();
            }
        });
    }

    // Status viewer close and navigation
    if (statusViewerClose) {
        statusViewerClose.addEventListener('click', hideStatusViewer);
    }
    if (prevStatusBtn) {
        prevStatusBtn.addEventListener('click', () => navigateStatus('prev'));
    }
    if (nextStatusBtn) {
        nextStatusBtn.addEventListener('click', () => navigateStatus('next'));
    }
    if (statusReplyBtn) {
        statusReplyBtn.addEventListener('click', replyToStatus);
    }
    if (statusReplyInput) {
        statusReplyInput.addEventListener('keypress', (e) => {
            if (e.key === 'Enter') {
                replyToStatus();
            }
        });
    }
    if (statusViewerModal) {
        statusViewerModal.addEventListener('click', function(e) {
            if (e.target === statusViewerModal) {
                hideStatusViewer();
            }
        });
    }

    // Add status modal
    if (addStatusBackBtn) {
        addStatusBackBtn.addEventListener('click', hideAddStatusModal);
    }
    if (addStatusPostBtn) {
        addStatusPostBtn.addEventListener('click', postStatus);
    }
    if (addStatusModal) {
        addStatusModal.addEventListener('click', function(e) {
            if (e.target === addStatusModal) {
                hideAddStatusModal();
            }
        });
    }

    // Status creation handlers
    handleStatusTypeSelection();
    handleBackgroundSelection();
    handleMediaSelection();

    // User avatar click for settings
    if (SettingControl) {
        SettingControl.addEventListener('click', showUserSettings);
    }

    // Settings modal close buttons
    if (settingsBackBtn) {
        settingsBackBtn.addEventListener('click', hideUserSettings);
    }
    if (settingsCloseBtn) {
        settingsCloseBtn.addEventListener('click', hideUserSettings);
    }
    if (userSettingsModal) {
        userSettingsModal.addEventListener('click', function(e) {
            if (e.target === userSettingsModal) {
                hideUserSettings();
            }
        });
    }

    // Edit profile modal close buttons
    if (editProfileBackBtn) {
        editProfileBackBtn.addEventListener('click', hideEditProfile);
    }
    if (editProfileSaveBtn) {
        editProfileSaveBtn.addEventListener('click', saveProfileChanges);
    }
    if (editProfileModal) {
        editProfileModal.addEventListener('click', function(e) {
            if (e.target === editProfileModal) {
                hideEditProfile();
            }
        });
    }

    // Chat header click for profile
    const chatUserInfo = document.querySelector('.chat-user-info');
    chatUserInfo.addEventListener('click', function(e) {
        if (!e.target.closest('.back-btn')) {
            showProfileModal();
        }
    });

    // Profile modal close buttons
    if (profileCloseBtn) {
        profileCloseBtn.addEventListener('click', hideProfileModal);
    }
    if (profileBackBtn) {
        profileBackBtn.addEventListener('click', hideProfileModal);
    }
    if (profileModal) {
        profileModal.addEventListener('click', function(e) {
            if (e.target === profileModal) {
                hideProfileModal();
            }
        });
    }

    // Chat menu
    chatMenuBtn.addEventListener('click', function(e) {
        e.preventDefault();
        e.stopPropagation();
        toggleChatMenu();
    });

    clearChatBtn.addEventListener('click', function(e) {
        e.preventDefault();
        clearChat();
        chatDropdownMenu.classList.remove('show');
    });

    closeChatBtn.addEventListener('click', function(e) {
        e.preventDefault();
        closeChat();
        chatDropdownMenu.classList.remove('show');
    });

    // Modal event listeners
    clearChatCancel.addEventListener('click', () => hideModal(clearChatModal));
    clearChatConfirm.addEventListener('click', confirmClearChat);
    closeChatCancel.addEventListener('click', () => hideModal(closeChatModal));
    closeChatConfirm.addEventListener('click', confirmCloseChat);

    // Close modals when clicking overlay
    clearChatModal.addEventListener('click', function(e) {
        if (e.target === clearChatModal) {
            hideModal(clearChatModal);
        }
    });

    closeChatModal.addEventListener('click', function(e) {
        if (e.target === closeChatModal) {
            hideModal(closeChatModal);
        }
    });

    // Close dropdown when clicking outside
    document.addEventListener('click', function(e) {
        if (!chatMenuBtn.contains(e.target) && !chatDropdownMenu.contains(e.target)) {
            chatDropdownMenu.classList.remove('show');
        }
        if (!contextMenu.contains(e.target)) {
            contextMenu.style.display = 'none';
        }
    });

    // Chat item event listeners
    const chatItems = document.querySelectorAll('.chat-item');
    chatItems.forEach(item => {
        item.removeEventListener('click', handleChatClick);
        item.removeEventListener('touchstart', handleChatClick);
        
        item.addEventListener('click', function(e) {
            e.preventDefault();
            e.stopPropagation();
            handleChatClick(this);
        });
        
        item.addEventListener('touchstart', function(e) {
            e.preventDefault();
            e.stopPropagation();
            handleChatClick(this);
        }, { passive: false });
    });

    // Back button
    backBtn.addEventListener('click', function(e) {
        e.preventDefault();
        e.stopPropagation();
        goBackToChats();
    });

    backBtn.addEventListener('touchstart', function(e) {
        e.preventDefault();
        e.stopPropagation();
        goBackToChats();
    }, { passive: false });

    // Search toggle button
    searchToggleBtn.addEventListener('click', function(e) {
        e.preventDefault();
        toggleChatSearch();
    });

    // Close search button
    closeSearchBtn.addEventListener('click', function(e) {
        e.preventDefault();
        closeChatSearch();
    });

    // Search navigation buttons
    prevSearchBtn.addEventListener('click', function(e) {
        e.preventDefault();
        navigateSearch('prev');
    });

    nextSearchBtn.addEventListener('click', function(e) {
        e.preventDefault();
        navigateSearch('next');
    });

    // Send button
    sendBtn.addEventListener('click', function(e) {
        e.preventDefault();
        sendMessage();
    });

    // Message input
    messageInput.addEventListener('keypress', (e) => {
        if (e.key === 'Enter') {
            e.preventDefault();
            sendMessage();
        }
    });

    // Chat search input
    chatSearchInput.addEventListener('input', (e) => {
        searchInChat(e.target.value);
    });

    chatSearchInput.addEventListener('keydown', (e) => {
        if (e.key === 'Enter') {
            e.preventDefault();
            if (e.shiftKey) {
                navigateSearch('prev');
            } else {
                navigateSearch('next');
            }
        } else if (e.key === 'Escape') {
            closeChatSearch();
        }
    });

    // File input
    fileInput.addEventListener('change', handleFileSelect);

    // Reply bar close
    replyBarClose.addEventListener('click', closeReplyBar);

    // Context menu events
    document.getElementById('replyOption').addEventListener('click', handleReply);
    document.getElementById('editOption').addEventListener('click', handleEdit);
    document.getElementById('copyOption').addEventListener('click', handleCopy);
    document.getElementById('deleteOption').addEventListener('click', handleDelete);

    // Message action buttons (arrow icons)
    chatMessages.addEventListener('click', handleMessageActionClick);

    // Sidebar search
    const searchInput = document.querySelector('.search-input');
    searchInput.addEventListener('input', (e) => {
        const searchTerm = e.target.value.toLowerCase();
        const chatItems = document.querySelectorAll('.chat-item');
        
        chatItems.forEach(item => {
            const chatName = item.querySelector('.chat-name').textContent.toLowerCase();
            const lastMessage = item.querySelector('.last-message').textContent.toLowerCase();
            
            if (chatName.includes(searchTerm) || lastMessage.includes(searchTerm)) {
                item.style.display = 'flex';
            } else {
                item.style.display = 'none';
            }
        });
    });
}


// Handle message action button click (arrow icon)
function handleMessageActionClick(e) {
    if (e.target.closest('.message-actions-btn')) {
        e.preventDefault();
        e.stopPropagation();
        
        const messageElement = e.target.closest('.message');
        if (messageElement && messageElement.dataset.messageId) {
            selectedMessage = messageElement;
            const rect = e.target.closest('.message-actions-btn').getBoundingClientRect();
            const isSentMessage = messageElement.classList.contains('sent');
            
            document.getElementById('editOption').style.display = isSentMessage ? 'block' : 'none';
            
            contextMenu.style.display = 'block';
            contextMenu.style.left = (rect.left - 75) + 'px';
            contextMenu.style.top = (rect.bottom + 5) + 'px';
            
            setTimeout(() => {
                const menuRect = contextMenu.getBoundingClientRect();
                if (menuRect.right > window.innerWidth) {
                    contextMenu.style.left = (window.innerWidth - menuRect.width - 10) + 'px';
                }
                if (menuRect.bottom > window.innerHeight) {
                    contextMenu.style.top = (rect.top - menuRect.height - 5) + 'px';
                }
            }, 10);
        }
    }
}

// Context menu handlers
function handleReply() {
    if (selectedMessage) {
        const messageContent = selectedMessage.querySelector('.message-content').textContent;
        const isReceived = selectedMessage.classList.contains('received');
        
        currentReplyingTo = {
            id: selectedMessage.dataset.messageId,
            content: messageContent,
            sender: isReceived ? chatName.textContent : 'You'
        };
        
        showReplyBar();
        contextMenu.style.display = 'none';
        messageInput.focus();
    }
}

function handleEdit() {
    if (selectedMessage && selectedMessage.classList.contains('sent')) {
        const messageContent = selectedMessage.querySelector('.message-content');
        const originalText = messageContent.textContent;
        
        selectedMessage.classList.add('editing');
        
        const editContainer = document.createElement('div');
        editContainer.innerHTML = `
            <input type="text" class="edit-input" value="${originalText}" />
            <div class="edit-actions">
                <button class="edit-btn cancel">Cancel</button>
                <button class="edit-btn save">Save</button>
            </div>
        `;
        
        messageContent.style.display = 'none';
        messageContent.parentNode.insertBefore(editContainer, messageContent);
        
        const editInput = editContainer.querySelector('.edit-input');
        const saveBtn = editContainer.querySelector('.save');
        const cancelBtn = editContainer.querySelector('.cancel');
        
        editInput.focus();
        editInput.select();
        
        saveBtn.addEventListener('click', () => {
            const newText = editInput.value.trim();
            if (newText && newText !== originalText) {
                messageContent.innerHTML = newText + '<span class="edited-label">edited</span>';
                updateMessageInData(selectedMessage.dataset.messageId, newText);
                showNotification('Message edited');
            }
            finishEditing();
        });
        
        cancelBtn.addEventListener('click', finishEditing);
        
        editInput.addEventListener('keypress', (e) => {
            if (e.key === 'Enter') {
                saveBtn.click();
            } else if (e.key === 'Escape') {
                cancelBtn.click();
            }
        });
        
        function finishEditing() {
            editContainer.remove();
            messageContent.style.display = 'block';
            selectedMessage.classList.remove('editing');
        }
    }
    contextMenu.style.display = 'none';
}

function handleCopy() {
    if (selectedMessage) {
        const messageContent = selectedMessage.querySelector('.message-content').textContent;
        navigator.clipboard.writeText(messageContent).then(() => {
            showNotification('Message copied to clipboard');
        });
    }
    contextMenu.style.display = 'none';
}

function handleDelete() {
    if (selectedMessage) {
        const messageId = selectedMessage.dataset.messageId;
        selectedMessage.style.animation = 'messageSlide 0.3s ease-out reverse';
        
        setTimeout(() => {
            selectedMessage.remove();
            removeMessageFromData(messageId);
            showNotification('Message deleted');
            
            const remainingMessages = chatMessages.querySelectorAll('.message');
            if (remainingMessages.length === 0) {
                showEmptyChatState();
            }
        }, 300);
    }
    contextMenu.style.display = 'none';
}

// Reply bar functions
function showReplyBar() {
    replyToName.textContent = currentReplyingTo.sender;
    replyBarContent.textContent = currentReplyingTo.content;
    replyBar.classList.add('show');
}

function closeReplyBar() {
    replyBar.classList.remove('show');
    currentReplyingTo = null;
}

// File handling
function handleFileSelect(e) {
    const files = Array.from(e.target.files);
    files.forEach(file => {
        sendFileMessage(file);
    });
    e.target.value = '';
}

function sendFileMessage(file) {
    const currentTime = new Date().toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'});
    const messageId = ++messageIdCounter;
    
    let fileContent = '';
    
    if (file.type.startsWith('image/')) {
        const reader = new FileReader();
        reader.onload = function(e) {
            fileContent = `
                <div class="image-message">
                    <img src="${e.target.result}" alt="${file.name}" />
                </div>
                <div>${file.name}</div>
            `;
            addMessageToChat(fileContent, true, currentTime, true, messageId);
            saveMessageToData(fileContent, true, currentTime, messageId);
        };
        reader.readAsDataURL(file);
    } else {
        const fileSize = formatFileSize(file.size);
        const fileIcon = getFileIcon(file.type);
        
        fileContent = `
            <div class="file-message">
                <div class="file-icon">
                    <i class="${fileIcon}"></i>
                </div>
                <div class="file-info">
                    <div class="file-name">${file.name}</div>
                    <div class="file-size">${fileSize}</div>
                </div>
            </div>
        `;
        addMessageToChat(fileContent, true, currentTime, true, messageId);
        saveMessageToData(fileContent, true, currentTime, messageId);
    }
    
    showNotification(`${file.name} sent`);
}

function formatFileSize(bytes) {
    if (bytes === 0) return '0 Bytes';
    const k = 1024;
    const sizes = ['Bytes', 'KB', 'MB', 'GB'];
    const i = Math.floor(Math.log(bytes) / Math.log(k));
    return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
}

function getFileIcon(fileType) {
    if (fileType.startsWith('image/')) return 'fas fa-image';
    if (fileType.startsWith('video/')) return 'fas fa-video';
    if (fileType.startsWith('audio/')) return 'fas fa-music';
    if (fileType.includes('pdf')) return 'fas fa-file-pdf';
    if (fileType.includes('word')) return 'fas fa-file-word';
    if (fileType.includes('excel') || fileType.includes('spreadsheet')) return 'fas fa-file-excel';
    if (fileType.includes('powerpoint') || fileType.includes('presentation')) return 'fas fa-file-powerpoint';
    if (fileType.includes('zip') || fileType.includes('rar')) return 'fas fa-file-archive';
    return 'fas fa-file';
}

// Data management functions
function updateMessageInData(messageId, newContent) {
    const currentChatName = chatName.textContent;
    const messages = currentChatData.messages[currentChatName];
    const message = messages.find(msg => msg.id == messageId);
    if (message) {
        message.content = newContent;
        message.edited = true;
    }
}

function removeMessageFromData(messageId) {
    const currentChatName = chatName.textContent;
    const messages = currentChatData.messages[currentChatName];
    const index = messages.findIndex(msg => msg.id == messageId);
    if (index > -1) {
        messages.splice(index, 1);
    }
}

function saveMessageToData(content, isSent, time, messageId, replyTo = null) {
    const currentChatName = chatName.textContent;
    if (!currentChatData.messages[currentChatName]) {
        currentChatData.messages[currentChatName] = [];
    }
    
    const messageData = {
        id: messageId,
        type: isSent ? 'sent' : 'received',
        content: content,
        time: time
    };
    
    if (replyTo) {
        messageData.replyTo = replyTo;
    }
    
    currentChatData.messages[currentChatName].push(messageData);
}

// Handle chat item click
function handleChatClick(element) {
    const name = element.getAttribute('data-name');
    const avatar = element.getAttribute('data-avatar');
    const status = element.getAttribute('data-status');
    const gradient = element.getAttribute('data-gradient');
    
    if (name && avatar && status) {
        openChat(name, avatar, status, gradient);
    }
}

// Open chat function
function openChat(name, avatar, status, gradient = '#ff6b6b, #feca57') {
    try {
        welcomeScreen.style.display = 'none';
        chatInterface.style.display = 'flex';
        
        chatName.textContent = name;
        chatStatus.textContent = status;
        chatAvatar.textContent = avatar;
        chatAvatar.style.background = `linear-gradient(45deg, ${gradient})`;
        
        currentChatInfo = currentChatData.profiles[name] || {
            type: 'contact',
            name: name,
            avatar: avatar,
            avatarGradient: `linear-gradient(45deg, ${gradient})`,
            status: status,
            isOnline: status === 'Online'
        };
        
        loadChatMessages(name);
        closeChatSearch();
        closeReplyBar();
        chatDropdownMenu.classList.remove('show');
        
        if (isMobileDevice()) {
            setTimeout(() => {
                sidebar.classList.add('hide');
                mainChat.classList.add('show');
            }, 50);
        }
        
        document.querySelectorAll('.chat-item').forEach(item => {
            item.classList.remove('active');
        });
        
        const clickedItem = document.querySelector(`[data-name="${name}"]`);
        if (clickedItem) {
            clickedItem.classList.add('active');
        }
        
        setTimeout(() => {
            chatMessages.scrollTop = chatMessages.scrollHeight;
        }, 100);
        
    } catch (error) {
        console.error('Error opening chat:', error);
    }
}

// Load chat messages
function loadChatMessages(chatName) {
    const messages = chatMessages.querySelectorAll('.message, .empty-chat');
    messages.forEach(msg => msg.remove());
    
    const messages_data = currentChatData.messages[chatName] || [];
    
    if (messages_data.length > 0) {
        messages_data.forEach(msg => {
            addMessageToChat(msg.content, msg.type === 'sent', msg.time, false, msg.id, msg.replyTo);
        });
    } else {
        showEmptyChatState();
    }
}

// Go back to chats
function goBackToChats() {
    if (isMobileDevice()) {
        sidebar.classList.remove('hide');
        mainChat.classList.remove('show');
        
        setTimeout(() => {
            chatInterface.style.display = 'none';
            welcomeScreen.style.display = 'flex';
        }, 300);
        
        closeChatSearch();
        closeReplyBar();
        chatDropdownMenu.classList.remove('show');
        
        document.querySelectorAll('.chat-item').forEach(item => {
            item.classList.remove('active');
        });
    }
}

// Chat search functionality
function toggleChatSearch() {
    if (isSearchActive) {
        closeChatSearch();
    } else {
        openChatSearch();
    }
}

function openChatSearch() {
    chatSearchContainer.classList.add('show');
    chatSearchInput.focus();
    isSearchActive = true;
}

function closeChatSearch() {
    chatSearchContainer.classList.remove('show');
    chatSearchInput.value = '';
    clearSearchResults();
    isSearchActive = false;
}

function clearSearchResults() {
    searchResults = [];
    currentSearchIndex = -1;
    updateSearchCount();
    
    const messages = chatMessages.querySelectorAll('.message');
    messages.forEach(message => {
        message.classList.remove('highlighted');
        const content = message.querySelector('.message-content');
        if (content) {
            content.innerHTML = content.textContent;
        }
    });
}

function searchInChat(query) {
    if (!query.trim()) {
        clearSearchResults();
        return;
    }

    searchResults = [];
    const messages = chatMessages.querySelectorAll('.message');
    
    messages.forEach((message, index) => {
        const content = message.querySelector('.message-content');
        if (content) {
            const text = content.textContent.toLowerCase();
            const searchQuery = query.toLowerCase();
            
            if (text.includes(searchQuery)) {
                searchResults.push({
                    element: message,
                    index: index,
                    content: content
                });
            }
        }
    });

    if (searchResults.length > 0) {
        currentSearchIndex = 0;
        highlightSearchResults(query);
        scrollToSearchResult(0);
    } else {
        currentSearchIndex = -1;
        clearHighlights();
    }

    updateSearchCount();
}

function highlightSearchResults(query) {
    const searchQuery = query.toLowerCase();
    
    searchResults.forEach((result, index) => {
        const content = result.content;
        const text = content.textContent;
        const regex = new RegExp(`(${escapeRegExp(query)})`, 'gi');
        const highlightedText = text.replace(regex, '<span class="highlight">$1</span>');
        content.innerHTML = highlightedText;
        
        if (index === currentSearchIndex) {
            result.element.classList.add('highlighted');
        } else {
            result.element.classList.remove('highlighted');
        }
    });
}

function clearHighlights() {
    const messages = chatMessages.querySelectorAll('.message');
    messages.forEach(message => {
        message.classList.remove('highlighted');
        const content = message.querySelector('.message-content');
        if (content) {
            content.innerHTML = content.textContent;
        }
    });
}

function navigateSearch(direction) {
    if (searchResults.length === 0) return;

    if (direction === 'next') {
        currentSearchIndex = (currentSearchIndex + 1) % searchResults.length;
    } else if (direction === 'prev') {
        currentSearchIndex = currentSearchIndex > 0 ? currentSearchIndex - 1 : searchResults.length - 1;
    }

    searchResults.forEach((result, index) => {
        if (index === currentSearchIndex) {
            result.element.classList.add('highlighted');
        } else {
            result.element.classList.remove('highlighted');
        }
    });

    scrollToSearchResult(currentSearchIndex);
    updateSearchCount();
}

function scrollToSearchResult(index) {
    if (searchResults[index]) {
        const element = searchResults[index].element;
        element.scrollIntoView({
            behavior: 'smooth',
            block: 'center'
        });
    }
}

function updateSearchCount() {
    if (searchResults.length > 0) {
        searchCount.textContent = `${currentSearchIndex + 1} of ${searchResults.length}`;
        prevSearchBtn.disabled = false;
        nextSearchBtn.disabled = false;
    } else {
        searchCount.textContent = chatSearchInput.value.trim() ? '0 of 0' : '';
        prevSearchBtn.disabled = true;
        nextSearchBtn.disabled = true;
    }
}

function escapeRegExp(string) {
    return string.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}

// Add message function
function addMessage(text, isSent = true) {
    const currentTime = new Date().toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'});
    const messageId = ++messageIdCounter;
    
    const emptyState = chatMessages.querySelector('.empty-chat');
    if (emptyState) {
        emptyState.remove();
    }
    
    addMessageToChat(text, isSent, currentTime, true, messageId, currentReplyingTo);
    saveMessageToData(text, isSent, currentTime, messageId, currentReplyingTo);

    if (currentReplyingTo) {
        closeReplyBar();
    }

    if (isSearchActive && chatSearchInput.value.trim()) {
        setTimeout(() => {
            searchInChat(chatSearchInput.value);
        }, 100);
    }
}

function addMessageToChat(text, isSent, time, animate = true, messageId = null, replyTo = null) {
    const messageDiv = document.createElement('div');
    messageDiv.className = `message ${isSent ? 'sent' : 'received'}`;
    if (messageId) {
        messageDiv.setAttribute('data-message-id', messageId);
    }
    if (animate) {
        messageDiv.style.animation = 'messageSlide 0.3s ease-out';
    }
    
    const statusIcon = isSent ? '<i class="fas fa-check-double message-status"></i>' : '';
    
    let replyHtml = '';
    if (replyTo) {
        replyHtml = `
            <div class="reply-info">
                <div class="reply-to">${replyTo.sender}</div>
                <div class="reply-text">${replyTo.content}</div>
            </div>
        `;
    }
    
    const actionsHtml = `
        <div class="message-actions">
            <div class="message-actions-btn">
                <i class="fas fa-chevron-down"></i>
            </div>
        </div>
    `;
    
    if (isSent) {
        messageDiv.innerHTML = `
            
            <div class="message-bubble">
                ${actionsHtml}
                ${replyHtml}
                <div class="message-content">${text}</div>
                <div class="message-time">
                    ${time}
                    ${statusIcon}
                </div>
            </div>
        `;
    } else {
        messageDiv.innerHTML = `
            <div class="message-bubble">
                ${replyHtml}
                <div class="message-content">${text}</div>
                <div class="message-time">${time}</div>
                 ${actionsHtml}
            </div>
           
        `;
    }
    
    chatMessages.insertBefore(messageDiv, typingIndicator);
    if (animate) {
        chatMessages.scrollTop = chatMessages.scrollHeight;
    }
}

function sendMessage() {
    const text = messageInput.value.trim();
    if (text) {
        addMessage(text, true);
        messageInput.value = '';
        
        typingIndicator.style.display = 'flex';
        
        setTimeout(() => {
            typingIndicator.style.display = 'none';
            const responses = [
                "That's interesting! Tell me more. 🤔",
                "I completely agree with you! 👍",
                "Thanks for sharing that with me. 😊",
                "That sounds like a great idea! 💡",
                "I'll definitely consider that. 🤝",
                "Awesome! Let's do it! 🚀",
                "Haha, that's funny! 😂",
                "Sure thing! No problem. ✅",
                "Interesting perspective! 🧠",
                "I love that idea! ❤️",
                "You're absolutely right! 💯",
                "That makes perfect sense. 🎯"
            ];
            const randomResponse = responses[Math.floor(Math.random() * responses.length)];
            addMessage(randomResponse, false);
        }, Math.random() * 2000 + 1000);
    }
}

// Handle window resize
window.addEventListener('resize', () => {
    if (window.innerWidth > 768) {
        sidebar.classList.remove('hide');
        mainChat.classList.remove('show');
    } else {
        if (chatInterface.style.display === 'flex') {
            sidebar.classList.add('hide');
            mainChat.classList.add('show');
        } else {
            sidebar.classList.remove('hide');
            mainChat.classList.remove('show');
        }
    }
});

// Touch gestures for mobile
let touchStartX = 0;
let touchEndX = 0;

function handleGesture() {
    if (isMobileDevice() && chatInterface.style.display === 'flex') {
        if (touchEndX > touchStartX + 50) {
            goBackToChats();
        }
    }
}

chatMessages.addEventListener('touchstart', e => {
    touchStartX = e.changedTouches[0].screenX;
}, { passive: true });

chatMessages.addEventListener('touchend', e => {
    touchEndX = e.changedTouches[0].screenX;
    handleGesture();
}, { passive: true });

// Initialize on DOM content loaded
document.addEventListener('DOMContentLoaded', function() {
    loadTheme();
    loadUserSettings();
    applyChatFontSize(userSettings.chat.fontSize);
    initializeEventListeners();
    
    setTimeout(() => {
        if (chatMessages.children.length > 0) {
            chatMessages.scrollTop = chatMessages.scrollHeight;
        }
    }, 100);

    if (isMobileDevice()) {
        chatInterface.style.display = 'none';
        welcomeScreen.style.display = 'flex';
        sidebar.classList.remove('hide');
        mainChat.classList.remove('show');
    }
});

// Initialize on window load as backup
window.addEventListener('load', () => {
    if (isMobileDevice()) {
        chatInterface.style.display = 'none';
        welcomeScreen.style.display = 'flex';
        sidebar.classList.remove('hide');
        mainChat.classList.remove('show');
    }
});


// Event listeners for modal close buttons (add these to your initialization)
function initializeCallEventListeners() {
    // Call modal close events
    if (endCallBtn) {
        endCallBtn.addEventListener('click', endCall);
    }
    
    // Close call modal when clicking outside
    if (callModal) {
        callModal.addEventListener('click', function(e) {
            if (e.target === callModal) {
                endCall();
            }
        });
    }
    
    // Incoming call modal events
    if (acceptCallBtn) {
        acceptCallBtn.addEventListener('click', acceptCall);
    }
    
    if (declineCallBtn) {
        declineCallBtn.addEventListener('click', declineCall);
    }
    
    // Close incoming call modal when clicking outside
    if (incomingCallModal) {
        incomingCallModal.addEventListener('click', function(e) {
            if (e.target === incomingCallModal) {
                declineCall();
            }
        });
    }
    
    // Call history modal events
    if (callHistoryBackBtn) {
        callHistoryBackBtn.addEventListener('click', hideCallHistoryModal);
    }
    
    if (callHistoryCloseBtn) {
        callHistoryCloseBtn.addEventListener('click', hideCallHistoryModal);
    }
    
    // Close call history modal when clicking outside
    if (callHistoryModal) {
        callHistoryModal.addEventListener('click', function(e) {
            if (e.target === callHistoryModal) {
                hideCallHistoryModal();
            }
        });
    }
    
    // ESC key to close modals
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            if (callModal.classList.contains('show')) {
                endCall();
            } else if (incomingCallModal.classList.contains('show')) {
                declineCall();
            } else if (callHistoryModal.classList.contains('show')) {
                hideCallHistoryModal();
            }
        }
    });
    
    // Call control button events
    if (muteBtn) {
        muteBtn.addEventListener('click', toggleMute);
    }
    
    if (speakerBtn) {
        speakerBtn.addEventListener('click', toggleSpeaker);
    }
    
    if (videoBtn) {
        videoBtn.addEventListener('click', toggleVideo);
    }
    
    if (cameraToggleBtn) {
        cameraToggleBtn.addEventListener('click', toggleVideo);
    }
    
    if (switchCameraBtn) {
        switchCameraBtn.addEventListener('click', switchCamera);
    }
}

initializeCallEventListeners();


