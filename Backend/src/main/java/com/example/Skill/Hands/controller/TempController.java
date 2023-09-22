package com.example.Skill.Hands.controller;

import com.example.Skill.Hands.entity.TestEntity;
import com.example.Skill.Hands.repository.TestRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.AutoConfiguration;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
public class TempController {

    @Autowired
    TestRepo repo;

    @GetMapping("/test_showSkills")
    public List<TestEntity> showSkills() {
        return repo.findAll();
    }

//    @GetMapping("/test_showSingleSkill")
//    public List<TestEntity> showSingleSkill(@RequestParam String skillName) {
//        TestEntity entity = repo.findByName(skillName);
//
//        if (entity != null) {
//            return repo.findAll();
//        }
//        return
//    }


}
