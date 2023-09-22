package com.example.Skill.Hands.repository;

import com.example.Skill.Hands.entity.BlockEntity;
import com.example.Skill.Hands.entity.DistrictEntity;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface BlockRepo extends JpaRepository<BlockEntity, Integer> {

    List<BlockEntity> findByDistrictCodeDistrictCode(int districtCode);

}
