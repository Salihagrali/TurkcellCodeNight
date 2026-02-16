package com.movies.turkcellnight.service;

import com.movies.turkcellnight.dtos.DailyPointsGraphDto;
import com.movies.turkcellnight.entity.PointsLedger;
import com.movies.turkcellnight.repository.PointsLedgerRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class LedgerService {

    private final PointsLedgerRepository ledgerRepository;

    public List<DailyPointsGraphDto> getDailyPointsGraph(String userId) {
        // 1. Kullanıcının tüm puan hareketlerini eskiden yeniye çek
        List<PointsLedger> ledgers = ledgerRepository.findByUser_UserIdOrderByCreatedAtAsc(userId);

        // 2. Tarihe göre (LocalDate) grupla ve o günkü puanları topla
        // Not: TreeMap kullanıyoruz çünkü tarihlerin sıralamasını (kronolojik) korumamız ŞART!
        Map<LocalDate, Integer> dailyPointsMap = ledgers.stream()
                .collect(Collectors.groupingBy(
                        // Null check: If date is missing, pretend it happened today
                        ledger -> ledger.getCreatedAt() != null
                                ? ledger.getCreatedAt().toLocalDate()
                                : LocalDate.now(),
                        TreeMap::new,
                        // Null check: If points are null, use 0
                        Collectors.summingInt(ledger -> ledger.getPointsDelta() != null ? ledger.getPointsDelta() : 0)
                ));

        // 3. Grafik verisini oluştur ve kümülatif toplamı hesapla
        List<DailyPointsGraphDto> graphData = new ArrayList<>();
        int runningTotal = 0;

        for (Map.Entry<LocalDate, Integer> entry : dailyPointsMap.entrySet()) {
            runningTotal += entry.getValue(); // Geçmişten bugüne puanı toplayarak ekle

            graphData.add(new DailyPointsGraphDto(
                    entry.getKey().toString(), // "2026-03-12"
                    entry.getValue(),          // Sadece o günkü kazanç (ör: 100)
                    runningTotal               // Toplam ulaşılan seviye (ör: 250)
            ));
        }

        return graphData;
    }
}