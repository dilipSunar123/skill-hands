package com.example.Skill.Hands.repository;

import com.example.Skill.Hands.entity.FeedbackEntity;
import org.springframework.data.jpa.repository.JpaRepository;

public interface FeedbackRepo extends JpaRepository<FeedbackEntity, Integer> {
}
