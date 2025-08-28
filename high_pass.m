    clear all; close all; clc;
    
    % Parametreleri tanımla
    fc = 8e6;        % Kesim frekansı: 8 MHz
    f_max = 15e6;    % Sinyalin maksimum frekansı: 15 MHz
    fs = 25e6;       % Örnekleme frekansı: 25 MHz
    
    % Frekans eksenini oluştur
    f = linspace(-30e6, 30e6, 3000);
    
    % Orijinal high-pass sinyal spektrumunu oluştur
    X_original = zeros(size(f));
    X_original((f <= -fc) & (f >= -f_max)) = 1;
    X_original((f >= fc) & (f <= f_max)) = 1;
    
    % Örneklenmiş sinyal spektrumunu oluştur (tekrarlamalarla)
    X_sampled = zeros(size(f));
    n = -3:3;  % Kaç tane tekrar gösterilecek
    
    for k = n
        % Negatif frekans bandı
        X_sampled = X_sampled + ((f >= k*fs - f_max) & (f <= k*fs - fc));
        % Pozitif frekans bandı
        X_sampled = X_sampled + ((f >= k*fs + fc) & (f <= k*fs + f_max));
    end
    
    % Grafiği çiz
    figure('Position', [100, 100, 900, 600])
    
    % Alt grafik 1: Orijinal high-pass sinyal spektrumu
    subplot(2,1,1)
    plot(f/1e6, X_original, 'b', 'LineWidth', 2)
    title('(a) Orijinal High-Pass Sinyal Spektrumu')
    xlabel('Frekans (MHz)')
    ylabel('Genlik')
    xlim([-30, 30])
    ylim([0, 1.2])
    grid on
    
    % Önemli noktaları işaretle
    hold on
    plot([-f_max, -fc]/1e6, [1, 1], 'ro', 'MarkerSize', 8, 'LineWidth', 2)
    plot([fc, f_max]/1e6, [1, 1], 'ro', 'MarkerSize', 8, 'LineWidth', 2)
    
    % Frekans etiketlerini ekle
    text(-f_max/1e6-1, 1.1, sprintf('-f_{max} = -%d MHz', f_max/1e6), 'HorizontalAlignment', 'right')
    text(-fc/1e6+1, 1.1, sprintf('-f_c = -%d MHz', fc/1e6), 'HorizontalAlignment', 'left')
    text(fc/1e6-1, 1.1, sprintf('f_c = %d MHz', fc/1e6), 'HorizontalAlignment', 'right')
    text(f_max/1e6+1, 1.1, sprintf('f_{max} = %d MHz', f_max/1e6), 'HorizontalAlignment', 'left')
    
    % Bant genişliğini göster
    bandwidth = f_max - fc;
    text(-(fc + bandwidth/2)/1e6, 0.5, sprintf('B = %d MHz', bandwidth/1e6), 'HorizontalAlignment', 'center')
    text((fc + bandwidth/2)/1e6, 0.5, sprintf('B = %d MHz', bandwidth/1e6), 'HorizontalAlignment', 'center')
    hold off
    
    % Alt grafik 2: Örneklenmiş sinyal spektrumu tekrarlamaları
    subplot(2,1,2)
    plot(f/1e6, X_sampled, 'r', 'LineWidth', 1.5)
    title(sprintf('(b) Örneklenmiş Sinyal Spektrumu (f_s = %d MHz)', fs/1e6))
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
            text(k*fs/1e6, 1.1, sprintf('%df_s', k), 'HorizontalAlignment', 'center')
        end
    end
    
    % DC noktasını işaretle
    text(0, 1.1, 'DC', 'HorizontalAlignment', 'center')
    text(fs/1e6/2, 0.5, sprintf('f_s = %d MHz', fs/1e6), 'HorizontalAlignment', 'center')
    
    % Orijinal spektrumun yerini göster
    plot([-f_max, -fc]/1e6, [1, 1], 'bo', 'MarkerSize', 8, 'LineWidth', 2)
    plot([fc, f_max]/1e6, [1, 1], 'bo', 'MarkerSize', 8, 'LineWidth', 2)
    
    % Önemli bölgeleri vurgula
    rectangle('Position', [-f_max/1e6, 0.9, (f_max-fc)/1e6, 0.1], 'FaceColor', 'y', 'EdgeColor', 'none', 'FaceAlpha', 0.3)
    rectangle('Position', [fc/1e6, 0.9, (f_max-fc)/1e6, 0.1], 'FaceColor', 'y', 'EdgeColor', 'none', 'FaceAlpha', 0.3)
    hold off
    
    % Grafiği düzenle
    set(gcf, 'Color', 'w')
    
    % Ek bilgi
    fprintf('High-Pass Filtre Parametreleri:\n');
    fprintf('Kesim Frekansı (fc): %d MHz\n', fc/1e6);
    fprintf('Maksimum Frekans (f_max): %d MHz\n', f_max/1e6);
    fprintf('Bant Genişliği (B): %d MHz\n', bandwidth/1e6);
    fprintf('Örnekleme Frekansı (fs): %d MHz\n', fs/1e6);
    fprintf('Nyquist Kriteri: fs > 2*f_max = %d MHz\n', 2*f_max/1e6);
