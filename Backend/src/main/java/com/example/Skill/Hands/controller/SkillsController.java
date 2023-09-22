package com.example.Skill.Hands.controller;

import com.example.Skill.Hands.dto.BlockDto;
import com.example.Skill.Hands.dto.SkillsDto;
import com.example.Skill.Hands.entity.DistrictEntity;
import com.example.Skill.Hands.entity.JobsEntity;
import com.example.Skill.Hands.entity.SkillsEntity;
import com.example.Skill.Hands.repository.BlockRepo;
import com.example.Skill.Hands.repository.DistrictRepo;
import com.example.Skill.Hands.repository.JobsRepo;
import com.example.Skill.Hands.repository.SkillsRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.swing.text.html.Option;
import java.util.List;
import java.util.Optional;

@RestController
public class SkillsController {

    @Autowired
    SkillsRepo skillsRepo;

    @Autowired
    DistrictRepo districtRepo;

    @Autowired
    JobsRepo jobsRepo;

    @GetMapping("/showSkills")
    public List<SkillsEntity> showSkills() {
        return skillsRepo.findAll();
    }

    @PostMapping("/addSkill")
    public ResponseEntity<?> addSkill(@RequestBody SkillsDto skillsDto) {
        SkillsEntity entity = new SkillsEntity();

        entity.setName(skillsDto.getName());
        entity.setContact(skillsDto.getContact());
        entity.setAddress(skillsDto.getAddress());
        entity.setRating(skillsDto.getRating());
        entity.setExperience(skillsDto.getExperience());

        entity.setJobsEntity(jobsRepo.getReferenceById((long) skillsDto.getJobId()));

        entity.setDistrictEntity(districtRepo.getReferenceById(skillsDto.getDistrictCode()));


        skillsRepo.save(entity);

        return ResponseEntity.ok("Skill added!");

    }


    @GetMapping("/findByJobId/{id}")
    public List<SkillsEntity> findByJobId(@PathVariable Long id) {
        List<SkillsEntity> entities = skillsRepo.findByJobsEntityJobId(id);

        return entities;
    }

    @GetMapping("/findById/{id}")
    public Optional<SkillsEntity> findById(@PathVariable int id) {
        return skillsRepo.findById((long)id);
    }

    @GetMapping("/findByDistrictCodeAndJobId/{districtCode}/{jobId}")
    public List<SkillsEntity> getByDistrictCodeAndJobId(@PathVariable int districtCode, @PathVariable int jobId) {

        List<SkillsEntity> entities = skillsRepo.findByDistrictEntityDistrictCodeAndJobsEntityJobId(districtCode, jobId);

        return entities;
    }

    @GetMapping("/findIdByName/{name}")
    public long findIdByName(@PathVariable String name) {

        SkillsEntity entity = skillsRepo.findByName(name);
        return entity.getId();
    }


}
