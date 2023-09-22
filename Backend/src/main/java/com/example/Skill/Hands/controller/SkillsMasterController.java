package com.example.Skill.Hands.controller;

import com.example.Skill.Hands.entity.SkillMasterEntity;
import com.example.Skill.Hands.repository.SkillsMasterRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

public class SkillsMasterController {

    @Autowired
    SkillsMasterRepo skillsMasterRepo;

    @PostMapping("/addNewSkill")
    public ResponseEntity addSkill(@RequestBody SkillMasterEntity skillMasterEntity) {

        skillsMasterRepo.save(skillMasterEntity);
        return ResponseEntity.ok("Skill added");

    }

}
