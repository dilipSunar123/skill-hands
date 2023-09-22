package com.example.Skill.Hands.controller;

import com.example.Skill.Hands.dto.FeedbackDto;
import com.example.Skill.Hands.entity.FeedbackEntity;
import com.example.Skill.Hands.repository.FeedbackRepo;
import com.example.Skill.Hands.repository.RegisterRepo;
import com.example.Skill.Hands.repository.SkillsRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
public class FeedbackController {

    @Autowired
    private FeedbackRepo feedbackRepo;
    @Autowired
    private RegisterRepo registerRepo;
    @Autowired
    private SkillsRepo skillsRepo;

    @GetMapping("/getAllFeedbacks")
    public List<FeedbackEntity> getAllFeedbacks() {
        return feedbackRepo.findAll();
    }

    @PostMapping("/addFeedback")
    private ResponseEntity addFeedback(@RequestBody FeedbackDto feedbackDto) {

        FeedbackEntity entity = new FeedbackEntity();

        entity.setRegisterEntity(registerRepo.getReferenceById((long)feedbackDto.getCitizenId()));
        entity.setSkillsEntity(skillsRepo.getReferenceById(feedbackDto.getSkillHandId()));
        entity.setFeedback(feedbackDto.getFeedback());

        feedbackRepo.save(entity);

        return ResponseEntity.ok("Feedback added");
    }



}
