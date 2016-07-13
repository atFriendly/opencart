<?php
class ModelUserAssignment extends Model {
    public function addAssignment($data) {
        $this->db->query("INSERT INTO " . DB_PREFIX . "user_assignment SET userId = '" . $this->db->escape($data['userId']) . "', customerId = '" . $this->db->excepe($data['customerId']) . "'");

        return $this->db->getLastId();
    }

    public function deleteAssignmentByUserId($userId) {
        $this->db->query("DELETE FROM " . DB_PREFIX . "user_assignment WHERE userId = '" . (int)$userId . "'");
    }

    public function getCustomerIdsByUserId($userId) {
        $query = $this->db->query("SELECT DISTINCT * FROM " . DB_PREFIX . "user_assignment WHERE userId = '" . (int)$userId . "'");

        $assignments = array(
            'userId'       => $query->row['userId'],
            'customerId'   => $query->row['customerId'],
        );

        return $assignments;
    }
}