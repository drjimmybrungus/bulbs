<!doctype html>
<html>
    <head>
        <title>${project} - ${title}</title>
        <link rel="stylesheet" href="${request.static_url('bulbs:static/css/foundation.min.css')}">
        <link rel="stylesheet" href="${request.static_url('bulbs:static/css/custom.css')}">
        <link rel="stylesheet" href="${request.static_url('bulbs:static/css/normalize.css')}">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.5.0/css/font-awesome.min.css">

        <%
            ident = request.session.get("identity") or False  
            
            if ident:
                is_logged_in = True
            else:
                is_logged_in = False
        %>

        <style>            
            body {
                padding: 0;
            }
        </style>

    </head>
    
    <body> 
        <nav class="top-bar" data-topbar role="navigation">
            <ul class="title-area">
                <li class="name">
                    <h1><a href="/"><i class="fa fa-lightbulb-o"></i></a></h1>
                </li>
                
                <!-- Remove the class "menu-icon" to get rid of menu icon. Take out "Menu" to just have icon alone -->
                <li class="toggle-topbar menu-icon"><a href="#"><span>Menu</span></a></li>
            </ul>

            <section class="top-bar-section">
                <!-- Right Nav Section -->
                
                % if is_logged_in:
                    <ul class="left">
                        % if ident.get("group_id") == 3:
                            <li id="nav-admin"><a href="/admin">Admin CP</a></li>
                        % endif
                    </ul>
                % endif
                
                <ul class="right">
                    <li id="nav-home"><a href="/">Home</a></li>

                    % if is_logged_in:
                            <li id="nav-user-cp"><a href="/control-panel">User CP</a></li>
                            <li id="nav-inbox"><a href="/inbox">Inbox</a></li>
                            <li id="nav-sign-out"><a href="/logout">Sign out</a></li>
                        % else:
                            <li id="nav-sign-in"><a href="/login">Sign in</a></li>
                    % endif
                    <!--
                    <li class="has-dropdown">
                        <a href="#">Right Button Dropdown</a>
                        
                        <ul class="dropdown">
                            <li><a href="#">First link in dropdown</a></li>
                            <li class="active"><a href="#">Active link in dropdown</a></li>
                        </ul>
                    </li>-->
                </ul>

                <!-- Left Nav Section
                <ul class="left">
                    <li><a href="#">Left Nav Button</a></li>
                </ul>
                -->
                
            </section>
        </nav>

        <script src="${request.static_url('bulbs:static/js/vendor/jquery.js')}"></script>

        <section class="child-content">
            ${self.body()}
        </section>
        
        <script src="${request.static_url('bulbs:static/js/custom.js')}"></script>
        <script src="${request.static_url('bulbs:static/js/foundation.min.js')}"></script>
        
        <script>
            $(document).foundation();
        </script>     
        
        <!--<footer style="bottom:0;width:100vw;">
            <div class="large-12 medium-12 text-center columns">
                <p class="subheader">Powered by <a href="https://github.com/galileo94/bulbs">Bulbs</a></p>
            </div>
        </footer>-->
           
    </body>
</html>
