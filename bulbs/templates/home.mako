<%inherit file="base.mako"/>

<%
    ident = request.session.get("identity") or False  
    
    if ident:
        is_logged_in = True
    else:
        is_logged_in = False
%>

<br>

<div class="row">
    <div class="large-6 columns">
        % if is_logged_in:
            <p>Logged in as ${ident.username}</p>
        % else:
            <p>Welcome, are you new here? <a href="/register">Click here</a> to sign up</a></p>
        % endif
    </div>

    <div class="large-6 columns text-right">
        % if is_logged_in:
            <p>There have been $n new posts since your last visit.</p>
        % endif
    </div>
</div>

% for category in categories:
    <div class="row">
        <div class="large-12 columns text-center rounded-pretty-blue">
            <span class="cat-name" style="background-color: #333; color: #eff; padding: 5px; " >${category.get("title")}</span>
        </div>
    </div>

    <r class="septerator">
    
    % for subcategory in subcategories:
        % if subcategory.get("category_id") == category.get("id"):
            <% lastpost = subcategory.get("last_post", None) %>
            
            
            <div class="row-background">
            <div class="subcat row">
                
                <div class="large-7 columns">
                    <span class="subcat-name">
                        <a class="subcat-title" href="${category.get('slug')}/${subcategory.get('slug')}">
                            ${subcategory.get("title")}
                        </a>
                    </span>
                    
                    <span class="subcat-desc">${subcategory.get("desc")}</span>
                </div>
                
                <div class="large-2 subcat-stats columns">
                    <span class="subcat-threads">${subcategory.get("threads")} Threads</span>
                    <span class="subcat-replies">${subcategory.get("posts")} Replies</span>
                </div>
                
                <div class="large-3 subcat-stats columns">
                    % if lastpost is not None:
                        <span class="last-post-date">${lastpost.get("date")}</span>
                        by <a href="#">${lastpost.get("username")}</a>
                    % endif
                </div>
                
            </div>
            </div>
        % endif
    % endfor        
    </div>
% endfor
