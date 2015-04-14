<?php
	/**
	* @author	Jeremy Daley
	* @desc		Basic Handle for MySQL DB "Selects" and "Inserts"
	*/
	class DBHandle
	{
		public $host = "localhost";
		public $error = "";
		public $connect;
		
		/**
		* @desc		Connects to the specified database with the specified credentials, using "localhost" as default MySQL host
		* 
		* @param	string	$database	// Database to connect to on current host
		* @param	string	$username	// Username of user connecting to specified database
		* @param	string	$password	// Password of user connecting to specified database
		* 
		* @return	bool	$connect_return
		*/
		public function connect($database, $username, $password)
		{
			$this->connect = mysqli_connect($this->host, $username, $password);
			$select = mysqli_select_db($this->connect, $database);
			if ($this->connect == false or $select == false)
			{
				$this->error = mysqli_error();
				return false;
			}
			else
			{
				return true;
			}
		}
		
		public function query($statement)
		{
			mysqli_query($statement);
		}
		
		/**
		* @desc		Selects records from current database using the specified SQL select statement
		*
		* @param	string	$statement	// SQL select statement
		*
		* @return	mixed	$returnVal	// Successful query returns an array of records, else false
		*/
		public function select($statement)
		{
			$returnVal = array();
			$result = mysqli_query($this->connect, $statement);
			if ($result == false)
			{
				$this->error = mysqli_error();
				return false;
			}
			while ($row = mysqli_fetch_assoc($result))
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
		public function select_as_xml($statement)
		{
			$return_xml = "<?xml version=\"1.0\" encoding=\"iso-8859-1\"?><results>";
			$result = mysqli_query($statement);
			if ($result == false)
			{
				$this->error = mysqli_error();
				return false;
			}
			while ($row = mysqli_fetch_assoc($result))
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
		* @return	bool	$insert_return	// Successful insert returns true, else false
		*/
		public function insert($table, $field_values)
		{
			$field_list = "";
			$value_list = "";
			
			foreach ($field_values as $key => $value)
			{
				$field_list .= "$key,";
				$value_list .= "'" . mysqli_real_escape_string($value) . "',";
			}
			
			$field_list = substr($field_list, 0, -1);
			$value_list = substr($value_list, 0, -1);
			
			$query = "INSERT INTO $table ($field_list) VALUES ($value_list)";
			
			$insert_return = mysqli_query($query);
			
			if ($insert_return == false) $this->error = mysqli_error();
			return $insert_return;
		}
		
		/**
		* @desc		Updates a record or records in the specified table based on a simple matched criteria (currently one WHERE condition)
		*
		* @param	string	$table			// Name of the table to update records in
		* @param	array	$field_values	// key => value array of field => value
		* @param	string	$search_field	// Field to do WHERE clause on
		* @param	string	$search_value	// Value to match on $search_field
		*
		* @return	bool	$update_return	// Successful update returns true, else false
		*/
		public function update($table, $field_values, $search_field = "", $search_value = "")
		{
			$set_list = "";
			
			foreach ($field_values as $key => $value)
			{
				$set_list .= "$key='" . mysqli_real_escape_string($value) . "',";
			}
			
			$set_list = substr($set_list, 0, -1);
			
			if ($search_field != "")
			{
				$query = "UPDATE $table SET $set_list WHERE $search_field='$search_value'";
			}
			else
			{
				$query = "UPDATE $table SET $set_list";
			}
			
			$update_return = mysqli_query($query);
			
			if ($update_return == false) $this->error = mysqli_error();
			return $update_return;
		}
		
		/**
		* @desc		Deletes a record or records in the specified table based on a simple matched criteria (currently one WHERE condition)
		*
		* @param	string	$table			// Name of the table to update records in
		* @param	string	$search_field	// Field to do WHERE clause on
		* @param	string	$search_value	// Value to match on $search_field
		*
		* @return	bool	$delete_return	// Successful delete returns true, else false
		*/
		public function delete($table, $search_field, $search_value)
		{
			$query = "DELETE FROM $table WHERE $search_field='$search_value'"; 
			
			$delete_return = mysqli_query($query);
			
			if ($delete_return == false) $this->error = mysqli_error();
			return $delete_return;
		}
		
		/**
		* @desc		Closes the current database connection
		*
		* @return	bool	$close_return
		*/
		public function close()
		{
			$close_return = mysqli_close($this->connect);
			return $close_return;
		}
		
		public function toggleBoolean($table, $field, $search_field = "", $search_value = "")
		{
			if ($search_field != "")
			{
				$query = "UPDATE $table SET $field = 1 - $field WHERE $search_field='$search_value'";
			}
			else
			{
				$query = "UPDATE $table SET $field = 1 - $field";
			}
			
			$update_return = mysqli_query($query);
			
			if ($update_return == false) $this->error = mysqli_error();
			return $update_return;
		}
		
		public function getNextPrimaryKey()
		{
			return mysqli_insert_id();
		}
	}
?>