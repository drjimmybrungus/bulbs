<%inherit file="base.mako"/>

<%
    ident = request.session.get("identity") or False  
    
    if ident:
        is_logged_in = True
    else:
        is_logged_in = False
%>



<style>
.row-container {
    padding: 20px;
    color: #333;
    
    transition: background 500ms ease;
    cursor: pointer;
}

/*.subcat-container {
    /*background-color: #1B3147;#22172A;
    padding: 20px;
    color: #333;
    
    transition: background 500ms ease;
    cursor: pointer;
}*/

.row-container:hover {
    background-color: #e9e9e9;
}

/*.subcat-container:hover {
    background-color: #E9E9E9;/*#403548;
}*/

.row-header-container {
    background-color: #42586e;
    padding: 5px 0 5px 0;
    color: #fff;
}

/*

.cat-container {
    background-color: #42586E;
    padding: 5px 0 5px 0;
    color: #fff;
}*/

.subcat-stats {
    display: block;
}

h4 {
    color: #8374AE;
}   

</style>


<br>


<div class="container">
    <div class="row">
        <div class="large-6 columns">
            % if is_logged_in:
                <p>Logged in as ${ident.get("username")}</p>
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
        <div class="row row-header-container">
            <div class="large-12 text-center columns">
                <span class="cat-name">${category.get("title")}</span>
            </div>
        </div>

        % for subcategory in subcategories:
            % if subcategory.get("category_id") == category.get("id"):
                <% last_post = subcategory.get("last_post", None) %>
                
                <div class="row row-container" data-cat="${category.get('slug')}" data-subcat="${subcategory.get('slug')}">
                    <div class="large-7 columns">
                        <div class="subcat-name">
                            <h4 style="margin: 0; padding: 0">
                                ${subcategory.get("title")}
                            </h4>
                        </div>
                        
                        <span class="subcat-desc">${subcategory.get("desc")}</span>
                    </div>
                    
                    <div class="large-2 columns subcat-stats">
                        <% t = "Thread" if subcategory.get("threads") == 1 else "Threads" %>
                        <% r = "Reply" if subcategory.get("posts") == 1 else "Replies" %>
                        <span class="subcat-threads">${subcategory.get("threads")} ${t}</span>
                        <span class="subcat-replies">${subcategory.get("posts")} ${r}</span>
                    </div>
                    
                    <div class="large-3 columns subcat-stats">
                        % if last_post is not None:
                            Last post by <a href="#">${last_post.get("username")}</a> on
                            <span class="last-post-date">${last_post.get("date")}</span>
                        % endif
                    </div>
                </div>
            % endif
        % endfor
    % endfor
</div>


<script>
$(function() {
    $("#nav-home").addClass("active");
    
    $(".row-container").click(function() {
        var cat = $(this).attr("data-cat");
        var subcat = $(this).attr("data-subcat")
        
        window.location.href = cat + "/" + subcat;        
    });
    
    
});
</script>
