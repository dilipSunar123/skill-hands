package com.example.Skill.Hands.controller;

import com.example.Skill.Hands.dto.BlockDto;
import com.example.Skill.Hands.entity.BlockEntity;
import com.example.Skill.Hands.entity.DistrictEntity;
import com.example.Skill.Hands.repository.BlockRepo;
import com.example.Skill.Hands.repository.DistrictRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Collections;
import java.util.List;

@RestController
public class BlockController {

    @Autowired
    private BlockRepo blockRepo;

    @Autowired
    private DistrictRepo districtRepo;

    @GetMapping("/findAllBlock")
    public List<BlockEntity> findAllBlock() {
        return blockRepo.findAll();
    }

    @PostMapping("/addBlock")
    public ResponseEntity addBlock(@RequestBody BlockDto blockDto) {
        BlockEntity entity = new BlockEntity();

        entity.setBlockCode(blockDto.getBlockCode());
        entity.setBlockName(blockDto.getBlockName());
         DistrictEntity districtEntity = districtRepo.getReferenceById(blockDto.getDistrictCode());
        entity.setDistrictCode(districtEntity);


        blockRepo.save(entity);

        return ResponseEntity.ok(entity + " added");
    }

    @GetMapping("/filterBlock/{districtCode}")
    public ResponseEntity<?> filterBlock(@PathVariable int districtCode) {
        List<BlockEntity> filteredBlocks = blockRepo.findByDistrictCodeDistrictCode(districtCode);

        if(filteredBlocks.isEmpty()){
            return new ResponseEntity<>( "No content found related to districtCode : "+districtCode, HttpStatus.NOT_FOUND);
        }else {
            return ResponseEntity.ok(filteredBlocks);
        }
    }
}
