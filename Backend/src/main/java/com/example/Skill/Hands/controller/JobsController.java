package com.example.Skill.Hands.controller;

import com.example.Skill.Hands.entity.JobsEntity;
import com.example.Skill.Hands.entity.SkillsEntity;
import com.example.Skill.Hands.repository.JobsRepo;
import com.example.Skill.Hands.repository.SkillsRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
public class JobsController {

    @Autowired
    private JobsRepo jobRepo;
    @Autowired
    private SkillsRepo skillsRepo;

    int jobId;

    @GetMapping("/showJobs")
    public List<JobsEntity> showJob() {
        return jobRepo.findAll();
    }


    @PostMapping("/addJob")
    public ResponseEntity add (@RequestBody JobsEntity entity) {
        jobRepo.save(entity);

        return ResponseEntity.ok("done");
    }


    @GetMapping("/findBySkill/{skill}")
    public int findBySkill(@PathVariable String skill) {

        if (jobRepo.findBySkill(skill) != null) {
            JobsEntity entity = jobRepo.findBySkill(skill);
            jobId = entity.jobId;

            return jobId;
        }
        return 0;
    }

}
