<?php
	/**
	* @author	Jeremy Daley
	* @desc		Basic Handle for MySQL DB "Selects" and "Inserts"
	*/
	class DBHandle
	{
		public $host = "localhost";
		public $error = "";
		
		/**
		* @desc		Connects to the specified database with the specified credentials, using "localhost" as default MySQL host
		* 
		* @param	string	$database	// Database to connect to on current host
		* @param	string	$username	// Username of user connecting to specified database
		* @param	string	$password	// Password of user connecting to specified database
		* 
		* @return	bool	$connect_return
		*/
		public function connect(string $database, string $username, string $password)
		{
			$connect = mysql_connect($this->host, $username, $password);
			$select = mysql_select_db($database);
			if ($connect == false or $select == false)
			{
				$this->error = mysql_error();
				return false;
			}
			else
			{
				return true;
			}
		}
		
		/**
		* @desc		Selects records from current database using the specified SQL select statement
		*
		* @param	string	$statement	// SQL select statement
		*
		* @return	mixed	$returnVal	// Successful query returns an array of records, else false
		*/
		public function select(string $statement)
		{
			$returnVal = array();
			$result = mysql_query($statement);
			if ($result == false)
			{
				$this->error = mysql_error();
				return false;
			}
			while ($row = mysql_fetch_assoc($result))
			{
				$returnVal[] = $row;
			}
			
			return $returnVal;
		}
		
		/**
		* @desc		Returns an XML formatted string of table records returned by MySQL
		*
		* @param	string	$statement		// SQL select statement
		*
		* @return	mixed	$return_xml		// Successful query returns an XML string of records, else false
		*/
		public function select_as_xml(string $statement)
		{
			$return_xml = "<?xml version=\"1.0\" encoding=\"iso-8859-1\"?><results>";
			$result = mysql_query($statement);
			if ($result == false)
			{
				$this->error = mysql_error();
				return false;
			}
			while ($row = mysql_fetch_assoc($result))
			{
				$return_xml .= "<result>";
				foreach($row as $key => $value)
				{
					$return_xml .= "<$key><![CDATA[$value]]></$key>";
				}
				$return_xml .= "</result>";
			}
			$return_xml .= "</results>";
			return $return_xml;
		}
		
		/**
		* @desc		Inserts a single record into the specified $table
		*
		* @param	string	$table			// Name of table to insert values into
		* @param	array	$field_values	// key => value array of field => value
		*
		* @return	bool	$insert_return	//
		*/
		public function insert(string $table, array $field_values)
		{
			$field_list = "";
			$value_list = "";
			
			foreach ($field_values as $key => $value)
			{
				$field_list .= "$key,";
				$value_list .= "'" . mysql_real_escape_string($value) . "',";
			}
			
			$field_list = substr($field_list, 0, -1);
			$value_list = substr($value_list, 0, -1);
			
			$query = "INSERT INTO $table ($field_list) VALUES ($value_list)";
			
			$insert_return = mysql_query($query);
			
			if ($insert_return == false) $this->error = mysql_error();
			return $insert_return;
		}
		
		/**
		* @desc		Closes the current database connection
		*
		* @return	bool	$close_return
		*/
		public function close()
		{
			$close_return = mysql_close();
			return $close_return;
		}
		
	}
?>