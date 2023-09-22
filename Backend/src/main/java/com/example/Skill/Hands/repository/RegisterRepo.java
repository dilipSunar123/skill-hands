package com.example.Skill.Hands.repository;

import com.example.Skill.Hands.entity.RegisterEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Repository;

@Repository
public interface RegisterRepo extends JpaRepository<RegisterEntity, Long> {

     RegisterEntity findByEmail(String email);
     RegisterEntity findByPassword(String password);

     RegisterEntity findByEmailAndPassword(String email, String password);

     RegisterEntity findNameByEmail(String email);

}
