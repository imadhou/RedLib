<?php

require_once ('config.php');
class BDD
{
    private static $instance;
    public $pdo;
    private function __construct()
    {
        try {
            $dsn = vsprintf('pgsql:host=%s;port=%s;dbname=%s;user=%s;password=%s', [
                'host' => HOST,
                'port' => PORT,
                'dbname' => DBNAME,
                'user' => USER,
                'password' => PASSWORD,
            ]);
            $this->pdo = new PDO($dsn);
            $this->pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
            $this->pdo->setAttribute(PDO::ATTR_EMULATE_PREPARES, false);
        } catch (PDOException $e) {
            echo $e->getMessage();
        } catch (Throwable $e) {
            echo $e->getMessage();
        }

    }

    public static function getInstance(){
        if (!isset(self::$instance)){
            self::$instance = new BDD();
        }
            return self::$instance;
    }


    public function executer($sql, $params=[] ){

        if ($query = $this->pdo->prepare($sql)){
            $x=1;
            if (count($params)){
                foreach ($params as $param){
                    $query->bindValue($x,$param);
                    $x++;
                }
            }
            if ($query->execute()){
                return $query->fetchAll(PDO::FETCH_ASSOC);
            }
            else {
                return [];
            }
        }
        return $this;
    }

    public function inserer($table, $fields=[]){
        $fieldString = '';
        $valueString = '';
        $values = [];

        foreach ($fields as $field => $value){
            $fieldString .= '`' . $field . '`,';
            $valueString .= '?,';
            $values[] = $value;
        }
        $fieldString = rtrim($fieldString, ',');
        $valueString = rtrim($valueString, ',');
        $sql = "INSERT INTO {$table} ({$fieldString}) VALUES ({$valueString})";

        if($this->executer($sql, $values)){
            return true;
        }
        return false;

    }




}
