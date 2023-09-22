package com.example.Skill.Hands.controller;

import com.example.Skill.Hands.entity.RegisterEntity;
import com.example.Skill.Hands.repository.RegisterRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.nio.file.Path;
import java.util.List;


@RestController
public class RegisterController {

    @Autowired
    public RegisterRepo repo;

    @GetMapping("/showDetails")
    public List<RegisterEntity> showDetails() {
        return repo.findAll();
    }

    @PostMapping("/addDetails")
    public ResponseEntity addDetails(@RequestBody RegisterEntity entity) {
        repo.save(entity);
        return ResponseEntity.ok("done");
    }

    @GetMapping("/get/{id}")
    public RegisterEntity getDetailsById(@PathVariable Long id) {
        return repo.findById(id).get();
    }


    @PutMapping("/updateDetail/{id}")
    public ResponseEntity<?> updateDetail(@PathVariable int id, @RequestBody RegisterEntity entity) {
        RegisterEntity entity1 = repo.findById((long) id).get();

        if(entity1 != null) {
            entity1.setId(id);
            entity1.setContact(entity.getContact());
            entity1.setPassword(entity.getPassword());
            entity1.setName(entity.getName());
            entity1.setEmail(entity.getEmail());

            repo.save(entity1);

            return new ResponseEntity<>("Updated Successfully", HttpStatus.OK);
        } else {
            return new ResponseEntity<>("Not Found", HttpStatus.BAD_REQUEST);
        }
    }

    @GetMapping("/findIdByEmail/{email}")
    public int findByEmail(@PathVariable String email) {

        RegisterEntity entity = repo.findByEmail(email);

        if (repo.findByEmail(email) != null) {
            return entity.getId();
        }
        return 0;
    }


    @DeleteMapping("/delete/{id}")
    public ResponseEntity<?> deleteTask(@PathVariable Long id) {
        boolean exists = repo.existsById(id);

        if (exists) {
            repo.deleteById(id);
            return new ResponseEntity<>("Task Deleted Successfully", HttpStatus.OK);
        }
        return new ResponseEntity<>("Something went wrong!", HttpStatus.BAD_REQUEST);
    }

    @GetMapping("/login")
    public boolean login(@RequestParam String email, @RequestParam String password) {
        RegisterEntity entity = repo.findByEmail(email);

        if (entity != null) {
            String emailFromDB = entity.getEmail();
            String passwordFromDB = entity.getPassword();

            if(email.equals(emailFromDB) && password.equals(passwordFromDB)){
                return true;
            }
            return false;
        }
        return false;
    }

    @GetMapping("/findInfoByEmail/{email}")
    public RegisterEntity findInfoByEmail(@PathVariable String email) {
        if (repo.findByEmail(email) != null) {
            return repo.findByEmail(email);
        }
        return null;
    }

//    @PutMapping("/update/{email}")
//    public RegisterEntity updateEntity(@RequestParam String name, @RequestParam String contact, @RequestParam String password, @PathVariable String email) {
//
//        if (repo.findByEmail(email) != null) {
//
//            RegisterEntity entity = new RegisterEntity();
//
//            entity.setName(name);
//            entity.setEmail(email);
//            entity.setContact(contact);
//            entity.setPassword(password);
//
//            repo.save(entity);
//
//            return entity;
//        }
//        return null;
//    }

    @GetMapping("/findNameByEmail/{email}")
    public String findNameByEmail(@PathVariable String email) {

        RegisterEntity entity = repo.findNameByEmail(email);

        if (entity != null) {
            return entity.getName();
        }
        return "";
    }

}
