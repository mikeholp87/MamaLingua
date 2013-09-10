<?php
	$username = 'mikeholp';
	$password = 'MamaLingua9@';

	$api = new API($username,$password);
	$api->handleCommand();
	
////////////////////////////////////////////////////////////////////////////////

class API
{
	private $pdo;

	function __construct($username,$password)
	{

		try{
			//Create database object
			$this->pdo = new PDO('mysql:host=mikeholp.db.10244483.hostedresource.com;dbname=mikeholp',$username,$password,array(PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES utf8"));
			$this->pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
			//echo 'created database<br>';
		}
		catch(PDOException $e){
			echo 'ERROR: '.$e->getMessage();
		}
	}
	
	function handleCommand(){
		// Figure out which command the client sent and let the corresponding
		// method handle it. If the command is unknown, then exit with an error
		// message.

		if (isset($_POST['cmd']))
		{
			switch (trim($_POST['cmd']))
			{
				//Fetch methods
				case 'fetch_vocab':$this->fetch_vocab();return;
			}
		}
	}
	
	function fetch_vocab(){
		$genre = $_POST['genre'];
		$language = $_POST['language'];
		$use_category = $_POST['use_category'];
		$category = $_POST['category'];
		$both = $_POST['both'];
		$search_text = "%".$_POST['search_text']."%";
		
		$genreCnt = 0;
		$letterCnt = 1;
		$currLetter = "";
		$alphabet = "";
		
		if(isset($use_category)){
			if($language == "English-Spanish"){
				$stmt = $this->pdo->prepare("SELECT DISTINCT category_english FROM mamalingua ORDER BY category_english ASC");
				$stmt->execute();
			}else{
				$stmt = $this->pdo->prepare("SELECT DISTINCT category_spanish FROM mamalingua ORDER BY category_spanish ASC");
				$stmt->execute();
			}
		}else if(isset($category)){
			if($language == "English-Spanish"){
				if(isset($genre)){
					$stmt = $this->pdo->prepare("SELECT DISTINCT(english_singular), english_plural, english_phonetics, spanish_fm, spanish_nofm, spanish_plural, spanish_phonetics FROM mamalingua WHERE category_english = ? AND genre = ? ORDER BY english_singular ASC");
					$stmt->execute(array($category, $genre));
				}else{
					$stmt = $this->pdo->prepare("SELECT DISTINCT(english_singular), english_plural, english_phonetics, spanish_fm, spanish_nofm, spanish_plural, spanish_phonetics FROM mamalingua WHERE category_english = ? ORDER BY english_singular ASC");
					$stmt->execute(array($category));
				}
			}else{
				if(isset($genre)){
					$stmt = $this->pdo->prepare("SELECT DISTINCT(spanish_nofm), spanish_fm, english_singular, english_plural, english_phonetics, spanish_plural, spanish_phonetics, TRIM(LEADING 'el' FROM spanish_nofm) AS spanish_alt FROM mamalingua WHERE category_spanish = ? AND genre = ? ORDER BY TRIM(LEADING 'la' FROM spanish_alt) ASC");
					$stmt->execute(array($category, $genre));
				}else{
					$stmt = $this->pdo->prepare("SELECT DISTINCT(spanish_nofm), spanish_fm, english_singular, english_plural, english_phonetics, spanish_plural, spanish_phonetics, TRIM(LEADING 'el' FROM spanish_nofm) AS spanish_alt FROM mamalingua WHERE category_spanish = ? ORDER BY TRIM(LEADING 'la' FROM spanish_alt) ASC");
					$stmt->execute(array($category));
				}
			}
		}else if(isset($both)){
			if($language == "English-Spanish"){
				$stmt = $this->pdo->prepare("SELECT DISTINCT(english_singular), english_plural, english_phonetics, spanish_fm, spanish_nofm, spanish_plural, spanish_phonetics FROM mamalingua WHERE english_singular LIKE ? ORDER BY english_singular ASC");
				$stmt->execute(array($search_text));
			}else{
				$stmt = $this->pdo->prepare("SELECT DISTINCT(spanish_nofm), spanish_fm, english_singular, english_plural, english_phonetics, spanish_plural, spanish_phonetics, TRIM(LEADING 'el' FROM spanish_nofm) AS spanish_alt FROM mamalingua WHERE spanish_nofm LIKE ? ORDER BY TRIM(LEADING 'la' FROM spanish_alt) ASC");
				$stmt->execute(array($search_text));
			}
		}else{
			if($language == "English-Spanish"){
				$stmt = $this->pdo->prepare("SELECT DISTINCT(english_singular), english_plural, english_phonetics, spanish_fm, spanish_nofm, spanish_plural, spanish_phonetics FROM mamalingua WHERE genre = ? ORDER BY english_singular ASC");
				$stmt->execute(array($genre));
			}else{
				$stmt = $this->pdo->prepare("SELECT DISTINCT(spanish_nofm), spanish_fm, english_singular, english_plural, english_phonetics, spanish_plural, spanish_phonetics, TRIM(LEADING 'el' FROM spanish_nofm) AS spanish_alt FROM mamalingua WHERE genre = ? ORDER BY TRIM(LEADING 'la' FROM spanish_alt) ASC");
				$stmt->execute(array($genre));
			}
		}
		
		$vocab = array();
		while ($object = $stmt->fetch(PDO::FETCH_OBJ)){
			$vocab[] = clone $object;
		}
		if (!$vocab){
			return (object)array();
		}
		else{
			foreach ($vocab as $word){
				if($language == "English-Spanish")
					$categories[$genreCnt] = $word->category_english;
				else
					$categories[$genreCnt] = $word->category_spanish;
				
				$alphabet[ucfirst($word->english_singular[0])] = $letterCnt++;
				
				$english_singulars[$genreCnt] = $word->english_singular;
				$english_plurals[$genreCnt] = $word->english_plural;
				$english_phonetics[$genreCnt] = $word->english_phonetics;
				
				$spanish_fm[$genreCnt] = rtrim($word->spanish_fm);
				$spanish_nofm[$genreCnt] = rtrim($word->spanish_nofm);
				$spanish_plurals[$genreCnt] = $word->spanish_plural;
				$spanish_phonetics[$genreCnt] = $word->spanish_phonetics;
				
				$genreCnt++;
			}
		}
		
		if(isset($use_category)){
			$response_array["categories"] = $categories;
		}else{
			$response_array["english_singulars"] = $english_singulars;
			$response_array["english_plurals"] = $english_plurals;
			$response_array["english_phonetics"] = $english_phonetics;
			$response_array["spanish_fm"] = $spanish_fm;
			$response_array["spanish_nofm"] = $spanish_nofm;
			$response_array["spanish_plurals"] = $spanish_plurals;
			$response_array["spanish_phonetics"] = $spanish_phonetics;
			$response_array["genres"] = $genreCnt;
			$response_array["alphabet"] = $alphabet;
		}
		
		echo json_encode($response_array);
	}
}
?>