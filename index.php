<?php session_start();?>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8" />
		<title>Profile Picture Uploader</title>
		
		<link href="css/default.css" rel="stylesheet" type="text/css" />
		<link href="scripts/fileuploader/fileuploader.css" rel="stylesheet" type="text/css" />
		<link href="scripts/Jcrop/jquery.Jcrop.css" rel="stylesheet" type="text/css" />
		
		<script type="text/javascript" src="scripts/jquery-1.7.1.min.js"></script>
		<script type="text/javascript" src="scripts/jquery-impromptu.js"></script>
		<script type="text/javascript" src="scripts/fileuploader/fileuploader.js"></script>
		<script type="text/javascript" src="scripts/Jcrop/jquery.Jcrop.min.js"></script>
		<script type="text/javascript" src="scripts/jquery-uberuploadcropper.js"></script>
		
		<script type="text/javascript">
             
			$(function() {
				
				$('#UploadImages').uberuploadcropper({
					//---------------------------------------------------
					// uploadify options..
					//---------------------------------------------------
					//'debug'		: true,
					'action'	: 'upload.php',
					'params'	: {},
					'allowedExtensions': ['jpg','jpeg','png','gif'],
					//'sizeLimit'	: 0,
					//'multiple'	: true,
					//---------------------------------------------------
					//now the cropper options..
					//---------------------------------------------------
					'aspectRatio': 1, 
					'allowSelect': false,			//can reselect
					'allowResize' : true,			//can resize selection
					'setSelect': [ 0, 0, 200, 200 ],	//these are the dimensions of the crop box x1,y1,x2,y2
					'minSize': [ 200, 200 ],			//if you want to be able to resize, use these
					'maxSize': [ 500, 500 ],
					//---------------------------------------------------
					//now the uber options..
					//---------------------------------------------------
					'folder': 'uploads/',			// only used in uber, not passed to server
					'cropAction': 'crop.php',		// server side request to crop image
					'onComplete': function(imgs,data){
                                            $(".qq-upload-list").empty();
                                            $('#progress').empty();
                                            $('#PhotoPrevs').empty();
						var $PhotoPrevs = $('#PhotoPrevs');
                                                var l = imgs.length-1;
                                                var dir = "<?php echo session_id() ?>";
						//for(var i=0,l=imgs.length; i<l; i++){
							$PhotoPrevs.append('<img src="uploads/'+ dir+ "/profile_pic" +'?d='+ (new Date()).getTime() +'" />');
						//}
                                                
					}
				});
				
			});
		</script>
                
	</head>

	<body>
            
		<div id="wrapper">
			<h1>Welcome Guest!</h1>
			
			<div id="PhotoPrevs">
				<!-- The cropped images will be populated here -->
                                <?php $session_id = session_id(); 
                                    if(!is_dir("uploads/".$session_id)){ ?>
                                     <img id="defaultimg" src="uploads/default.jpg"/>
                                     <?php } else {?>
                                     <img id="defaultimg" src="uploads/<?php echo $session_id ?>/profile_pic" width="199px" height="200px"/>
                                     <?php } ?>
                                 <object id="cam" width="250" height="225" style="display: none">
                                <param name="movie" value="test.swf">
                                <embed src="test.swf" width="250" height="225"></embed>
                                </object>
			</div>
			<div id="UploadImages">
				<noscript>Please enable javascript to upload and crop images.</noscript>
			</div> OR <br><br>
                        <button id="cambut" onclick="showCam()"> Capture Image with webcam</button>
                        
                        <div id="progress" class="progress"></div>
		</div>
            <script type="text/javascript">
                function showCam(){
                    $("#defaultimg").hide();
                    $("#cam").show();
                }
        </script>
	</body>
</html>
