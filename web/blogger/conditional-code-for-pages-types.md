# Archive

<b:if cond='data:blog.pageType == "archive"'>
  <!--archive_Page-->
</b:if>

# Error page ~ 404

<b:if cond='data:blog.pageType == "error_page"'>
  <!-- all error pages-->
</b:if>

# Index page ~ home/main page

<b:if cond='data:blog.pageType == "index"'>
  <!-- all index pages -->
</b:if>

<b:if cond='data:blog.url == data:blog.homepageUrl'> 
  <!-- only homepage -->
</b:if>

# Item ~ blog article

<b:if cond='data:blog.pageType == "item"'>
  <!-- all item pages -->
</b:if>

<b:if cond='data:blog.url == data:blog.canonicalHomepageUrl + "2014/08/foo.html"'> 
  <!-- a item page from august 2014 with post-title 'foo'-->
</b:if>

# Label page ~ page with list of post for a label

<b:if cond='data:blog.searchLabel'>
  <!-- all label pages -->
</b:if>

<b:if cond='data:blog.searchLabel == "foo"'>
  <!-- for label 'foo' -->
</b:if>

# Search page ~ page used to make searches on the blog

<b:if cond='data:blog.searchQuery'>
    <!-- all search pages -->
</b:if>

<b:if cond='data:blog.searchQuery == "foo"'>
  <!-- for query 'foo' -->
</b:if>

# Static page ~ individual page

<b:if cond='data:blog.pageType == "static_page"'>
  <!-- all static pages -->
</b:if>

<b:if cond='data:blog.url == data:blog.canonicalHomepageUrl + "p/foo.html"'> 
  <!-- a specific static page with name 'foo' -->
</b:if>
