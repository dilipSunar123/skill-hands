package com.example.Skill.Hands.repository;

import com.example.Skill.Hands.entity.TestEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TestRepo extends JpaRepository<TestEntity, Long> {

    public TestEntity findByName(String skillName);

}
