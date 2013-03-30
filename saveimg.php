<?php
session_start();
$session_id = session_id();
if(!is_dir("uploads/$session_id"))
	mkdir("uploads/$session_id");
if ( isset ( $GLOBALS["HTTP_RAW_POST_DATA"] )) {
	$uniqueStamp = date(U);
	$filename = "uploads/$session_id/profile_pic";
	$fp = fopen( $filename,"wb");
	fwrite( $fp, $GLOBALS[ 'HTTP_RAW_POST_DATA' ] );
	fclose( $fp );
	echo "filename=".$filename."&base=".$_SERVER["HTTP_HOST"].dirname($_SERVER["PHP_SELF"]."/uploads");
}
?>

