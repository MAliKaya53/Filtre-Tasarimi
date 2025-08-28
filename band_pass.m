    clear all; close all; clc;

    % Parametreleri tanımla
    fc = 20e6;       % Merkez frekansı: 20 MHz
    B = 5e6;         % Bant genişliği: 5 MHz
    fs = 17.5e6;     % Örnekleme frekansı: 17.5 MHz
    % fs >= 2fc olmalı (NYQUIST)
    
    % Frekans eksenini oluştur
    f = linspace(-30e6, 30e6, 2000);
    % Orijinal band-pass sinyal spektrumunu oluştur
    X_original = zeros(size(f));
    X_original((f >= fc-B/2) & (f <= fc+B/2)) = 1;
    X_original((f >= -fc-B/2) & (f <= -fc+B/2)) = 1;
    % Örneklenmiş sinyal spektrumunu oluştur (tekrarlamalarla)
    X_sampled = zeros(size(f));
    n = -3:3;  % Kaç tane tekrar gösterilecek
    
    for k = n
        X_sampled = X_sampled + ((f >= k*fs + fc-B/2) & (f <= k*fs + fc+B/2));
        X_sampled = X_sampled + ((f >= k*fs - fc-B/2) & (f <= k*fs - fc+B/2));
    end
    
    % Grafiği çiz
    figure('Position', [100, 100, 900, 600])
    
    % Alt grafik 1: Orijinal sürekli sinyal spektrumu
    subplot(2,1,1)
    plot(f/1e6, X_original, 'b', 'LineWidth', 2)
    title('(a) Orijinal Sürekli Sinyal Spektrumu')
    xlabel('Frekans (MHz)')
    ylabel('Genlik')
    xlim([-30, 30])
    ylim([0, 1.2])
    grid on
    
    % Önemli noktaları işaretle
    hold on
    plot([-fc-B/2, -fc+B/2]/1e6, [1, 1], 'ro', 'MarkerSize', 8, 'LineWidth', 2)
    plot([fc-B/2, fc+B/2]/1e6, [1, 1], 'ro', 'MarkerSize', 8, 'LineWidth', 2)
    text(-22.5/1e6, 1.1, '-f_c = -20 MHz', 'HorizontalAlignment', 'center')
    text(22.5/1e6, 1.1, 'f_c = 20 MHz', 'HorizontalAlignment', 'center')
    text(-17.5/1e6, 0.5, 'B = 5 MHz', 'HorizontalAlignment', 'center')
    text(17.5/1e6, 0.5, 'B = 5 MHz', 'HorizontalAlignment', 'center')
    hold off
    
    % Alt grafik 2: Örneklenmiş sinyal spektrumu tekrarlamaları
    subplot(2,1,2)
    plot(f/1e6, X_sampled, 'r', 'LineWidth', 1.5)
    title('(b) Örneklenmiş Sinyal Spektrumu Tekrarlamaları (f_s = 17.5 MHz)')
    xlabel('Frekans (MHz)')
    ylabel('Genlik')
    xlim([-30, 30])
    ylim([0, 1.2])
    grid on
    
    % Örnekleme frekansı ve tekrarları işaretle
    hold on
    for k = n
        if k ~= 0
            plot([k*fs, k*fs]/1e6, [0, 1], 'k--', 'LineWidth', 1)
        end
    end
    text(0, 1.1, 'DC', 'HorizontalAlignment', 'center')
    text(fs/1e6, 1.1, 'f_s = 17.5 MHz', 'HorizontalAlignment', 'center')
    text(-fs/1e6, 1.1, '-f_s = -17.5 MHz', 'HorizontalAlignment', 'center')
    text(-2.5, 0.5, '-2.5 MHz', 'HorizontalAlignment', 'center')
    hold off
    
    % Grafiği düzenle
    set(gcf, 'Color', 'w')
