<?php

	//echo 'MYTEAM TEST PAGE<br>';

	$username = '';
	$password = '';

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
			$this->pdo = new PDO('mysql:host=localhost;dbname=mamalingua',$username,$password);
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
				//Search methods
				case 'search_teams':$this->search_teams();return;
				
				//Fetch methods
				case 'fetch_profile':$this->fetch_profile();return;
				case 'fetch_roster':$this->fetch_roster();return;
				
				//Create methods
				case 'add_roster':$this->add_roster();return;
				
				//Delete methods
				case 'delete_account':$this->delete_account();return;
				case 'delete_roster':$this->delete_roster();return;
			}
		}
	}
	
	function search_teams(){
		$team_name = $_POST['team_name'];
		$organization = $_POST['organization'];
		$age = $_POST['age'];
		$sport_type = $_POST['sport_type'];
		$city = $_POST['city'];
		
		$stmt = $this->pdo->prepare('SELECT * FROM team WHERE team_name LIKE ? OR organization LIKE ? OR age LIKE ? OR sport_type LIKE ? OR city LIKE ?');
		$stmt->execute(array($team_name, $organization, $age, $sport_type, $city));
		$teams = array();
		while ($object = $stmt->fetch(PDO::FETCH_OBJ)){
			$teams[] = clone $object;
		}
		if (!$teams){
			return (object)array();
		}
		else{
			foreach ($teams as $team){
				$names[$team->id] = $team->team_name;
			}
			//$response_array["team_name"] = $names;
			echo json_encode($names);
		}
	}
	
	function delete_account(){
		$udid = $_POST['udid'];

		$stmt = $this->pdo->prepare('DELETE FROM account WHERE udid = ?');
		$stmt->execute(array($udid));
		return;
	}
	
	function delete_roster(){
		$user_id = $_POST['user_id'];
		$team_id = $_POST['team_id'];
		$first_name = $_POST['first_name'];
		$last_name = $_POST['last_name'];
		$phone = $_POST['phone'];

		$stmt = $this->pdo->prepare('DELETE FROM roster WHERE team_id = ? AND first_name = ? AND last_name = ? AND phone = ?');
		$stmt->execute(array($team_id, $first_name, $last_name, $phone));
		
		$stmt = $this->pdo->prepare('DELETE FROM translate_account_team WHERE team_id = ? AND account_id = ?');
		$stmt->execute(array($team_id, $user_id));
		return;
	}
	
	function fetch_profile(){
		$udid = $_POST['udid'];
		
		$stmt = $this->pdo->prepare('SELECT * FROM account LEFT JOIN translate_account_team ON account.id = translate_account_team.account_id LEFT JOIN team ON team.id = translate_account_team.team_id WHERE udid = ?');
		$stmt->execute(array($udid));
		
		$user = $stmt->fetch(PDO::FETCH_OBJ);
		if($user) {
			$response_array["user_id"] = $user->id;
			$response_array["team_name"] = $user->team_name;
			$response_array["user_name"] = $user->name;
			$response_array["phone_number"] = $user->phone;
			$response_array["email_address"] = $user->email;
		}
		echo json_encode($response_array);
	}
	
	function add_roster(){
		$team_id = $_POST['team_id'];
		$first_name = $_POST['first_name'];
		$last_name = $_POST['last_name'];
		$phone = $_POST['phone'];
		$email = $_POST['email'];
	
		if(isset($phone)){
			$now = date("Y-m-d H:i:s");
			$stmt = $this->pdo->prepare('INSERT INTO roster (team_id, first_name, last_name, phone, created_time, last_updated) VALUES (?, ?, ?, ?, ?, ?)');
			$stmt->execute(array($team_id, $first_name, $last_name, $phone, $now, $now));
		
			$stmt = $this->pdo->prepare('SELECT id FROM account WHERE phone = ? LIMIT 1');
			$stmt->execute(array($phone));
			$user_id = $stmt->fetch(PDO::FETCH_OBJ)->id;
		
			if(isset($user_id))
				echo "SMS";
			else
				echo "SMS/Link";
		
			$now = date("Y-m-d H:i:s");
			$stmt = $this->pdo->prepare('INSERT INTO translate_account_team (account_id, team_id, permission, created_time) VALUES (?, ?, ?, ?)');
			$stmt->execute(array($user_id, $team_id, 0, $now));
		}
		
		else if(isset($email)){
			$now = date("Y-m-d H:i:s");
			$stmt = $this->pdo->prepare('INSERT INTO roster (team_id, first_name, last_name, email, created_time, last_updated) VALUES (?, ?, ?, ?, ?, ?)');
			$stmt->execute(array($team_id, $first_name, $last_name, $email, $now, $now));
		
			$stmt = $this->pdo->prepare('SELECT id FROM account WHERE email = ? LIMIT 1');
			$stmt->execute(array($email));
			$user_id = $stmt->fetch(PDO::FETCH_OBJ)->id;
		
			if(isset($user_id))
				echo "SMS";
			else
				echo "SMS/Link";
		
			$now = date("Y-m-d H:i:s");
			$stmt = $this->pdo->prepare('INSERT INTO translate_account_team (account_id, team_id, permission, created_time) VALUES (?, ?, ?, ?)');
			$stmt->execute(array($user_id, $team_id, 0, $now));
		}
		
		return;
	}
	
	function fetch_roster(){
		$team_id = $_POST['team_id'];
		
		$stmt = $this->pdo->prepare('SELECT * FROM roster WHERE team_id = ?');
		$stmt->execute(array($team_id));
		
		$rosters = array();
		while ($object = $stmt->fetch(PDO::FETCH_OBJ)){
			$rosters[] = clone $object;
		}
		if (!$rosters){
			return (object)array();
		}
		else{
			$i=0;
			foreach ($rosters as $roster){
				$jersey_numbers[$i] = $roster->jersey_number;
				$first_names[$i] = $roster->first_name;
				$last_names[$i] = $roster->last_name;
				$phones[$i] = $roster->phone;
				$emails[$i] = $roster->email;
				$team_access[$i] = $roster->team_access;
				$roster_access[$i] = $roster->roster_access;
				$user_type[$i] = $roster->user_type;
				$i++;
			}
		}
		$response_array["jersey_numbers"] = $jersey_numbers;
		$response_array["first_names"] = $first_names;
		$response_array["last_names"] = $last_names;
		$response_array["phones"] = $phones;
		$response_array["emails"] = $emails;
		$response_array["team_access"] = $team_access;
		$response_array["roster_access"] = $roster_access;
		$response_array["user_type"] = $user_type;
		echo json_encode($response_array);
	}
}
?>