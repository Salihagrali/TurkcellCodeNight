package com.movies.turkcellnight.service;

import com.movies.turkcellnight.entity.UserEntity;
import com.movies.turkcellnight.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class UserService {

    private final UserRepository userRepository;

    // CREATE
    public UserEntity createUser(UserEntity user) {
        // Ensure new users always start with 0 points
        user.setTotalPoints(0);
        log.info("Creating new user with ID: {}", user.getUserId());
        return userRepository.save(user);
    }

    // READ (All)
    public List<UserEntity> getAllUsers() {
        return userRepository.findAll();
    }

    // READ (Single User)
    public UserEntity getUserById(String userId) {
        return userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found with ID: " + userId));
    }

    // UPDATE
    public UserEntity updateUser(String userId, UserEntity updatedData) {
        UserEntity existingUser = getUserById(userId); // Throws error if not found

        existingUser.setName(updatedData.getName());
        existingUser.setCity(updatedData.getCity());
        existingUser.setSegment(updatedData.getSegment());

        // We usually don't let the user update their own points manually here,
        // that will be handled by the Gamification Engine!

        log.info("Updated user with ID: {}", userId);
        return userRepository.save(existingUser);
    }

    // DELETE
    public void deleteUser(String userId) {
        UserEntity existingUser = getUserById(userId);
        userRepository.delete(existingUser);
        log.info("Deleted user with ID: {}", userId);
    }
}