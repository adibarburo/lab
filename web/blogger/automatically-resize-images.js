<script language='javascript' src='https://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js' type='text/javascript'/>
  <script type='text/javascript'>
    //<![CDATA[
     $(document).ready(function() {
       $.fn.resizeImage = function() {
       $('.post-body').table_to_div();
         var postWidth = $('.post-body').width();  
         var sAttribut = /\/s\B\d{2,4}/;
         
         $('.post-body').find('img').each(function(n, image){
           var thisHeight = $(this).height();
           var thisWidth = $(this).width();
	   var thisRatio = thisWidth / thisHeight;
           var newWidth = postWidth; 
           var newHeight = Math.round(newWidth / thisRatio);	
           var newDimension;
             if(thisWidth >= thisHeight) {
             newDimension = newWidth    
             }
             else {
             newDimension = newHeight
             };	     
           var image = $(image);
           image.removeAttr("width height");
           image.css({
             "margin-left": "0",
             "padding":"0",
             "box-sizing": "border-box",
             "box-shadow": "0 0 0 rgba(0, 0, 0, 0)",
             "width": newWidth + "px",
             });	
           image.parent().removeAttr("style");
           image.attr({src : image.attr('src').replace( sAttribut,'/' + 's' + newDimension )});
           image.attr('width',newWidth);
           });
        };
$.fn.table_to_div = function() {
    $(this).find('table').each(function(){
    $(this).find('a').unwrap().unwrap();
    $(this).find('.tr-caption').unwrap();
    $(this).replaceWith( $('table').html()
      .replace(/<tbody/gi, "<div class='separator' style='clear: both; text-align: center'")
      .replace(/<tr/gi, "<div style='text-align: center'")
      .replace(/<\/tr>/gi, "</div>")
      .replace(/<td/gi, "<div")
      .replace(/<\/td>/gi, "</div>")
      .replace(/<\/tbody/gi, "<\/div")
     );
  });
};
   $('body').resizeImage();
   $(window).resize(function() {
      $('body').resizeImage();
    });
 });
//]]>
</script>
