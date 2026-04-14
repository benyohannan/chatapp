<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    jakarta.servlet.http.HttpSession currentSession = request.getSession(false);
    if (currentSession == null || currentSession.getAttribute("username") == null) {
        response.sendRedirect(response.encodeRedirectURL(request.getContextPath() + "/auth.jsp"));
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<%@ include file="includes/header.jsp" %>
<body class="app-booting">
    <script>
        (function() {
            try {
                var savedTheme = localStorage.getItem('RainChatify-theme');
                if (savedTheme === 'light') {
                    document.body.classList.add('light-mode');
                } else {
                    document.body.classList.remove('light-mode');
                }
            } catch (e) {
                document.body.classList.remove('light-mode');
            }
        })();
    </script>
    <div id="globalPageLoader" class="zync-global-loader" aria-live="polite" aria-label="Loading ZyncChat">
        <div class="zync-loader-center">
            <div class="zync-loader-ring"></div>
            <h1 class="zync-loader-brand">ZyncChat</h1>
            <div class="zync-loader-text" id="globalPageLoaderText">Preparing conversations</div>
            <div class="zync-loader-line"><span></span></div>
        </div>
    </div>
    <div class="RainChatify-container">
 
    
        <%@ include file="includes/sidebar.jsp" %>
        <%@ include file="includes/chatlist.jsp" %>
        <%@ include file="includes/mainChat.jsp" %>
       
    </div>
    <%@ include file="includes/modals.jsp" %>
    <%@ include file="includes/groupchat.jsp" %>
    <script>
        (function() {
            var loader = document.getElementById('globalPageLoader');
            var loaderText = document.getElementById('globalPageLoaderText');
            var minVisibleMs = 1150;
            var startedAt = Date.now();
            var hidden = false;

            function hideGlobalLoader() {
                if (hidden || !loader) {
                    return;
                }
                hidden = true;
                loader.classList.add('hide');
                document.body.classList.remove('app-booting');
                window.setTimeout(function() {
                    loader.style.display = 'none';
                }, 720);
            }

            function showGlobalLoader(label) {
                if (!loader) {
                    return;
                }
                hidden = false;
                if (label && loaderText) {
                    loaderText.textContent = String(label);
                }
                loader.style.display = 'flex';
                loader.classList.remove('hide');
                document.body.classList.add('app-booting');
            }

            window.ZyncLoader = {
                show: showGlobalLoader,
                hide: hideGlobalLoader,
                setText: function(label) {
                    if (loaderText && label) {
                        loaderText.textContent = String(label);
                    }
                }
            };

            window.addEventListener('load', function() {
                var elapsed = Date.now() - startedAt;
                var wait = Math.max(0, minVisibleMs - elapsed);
                window.setTimeout(hideGlobalLoader, wait);
            });
        })();
    </script>
</body>
</html>