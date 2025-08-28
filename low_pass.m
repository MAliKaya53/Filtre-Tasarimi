    clear all; close all; clc;
    
    % Parametreleri tanımla
    fm = 5e6;        % Sinyalin maksimum frekansı: 5 MHz
    fs1 = 12e6;      % Nyquist örnekleme frekansı: 12 MHz (fs > 2*fm)
    fs2 = 8e6;       % Yetersiz örnekleme frekansı: 8 MHz (fs < 2*fm)
    
    % Frekans eksenini oluştur
    f = linspace(-15e6, 15e6, 2000);
    
    % Orijinal low-pass sinyal spektrumunu oluştur
    X_original = zeros(size(f));
    X_original((f >= -fm) & (f <= fm)) = 1;
    
    % Nyquist örneklemesi ile örneklenmiş sinyal spektrumunu oluştur
    X_sampled_nyquist = zeros(size(f));
    n = -2:2;  % Kaç tane tekrar gösterilecek
    
    for k = n
        X_sampled_nyquist = X_sampled_nyquist + ((f >= k*fs1 - fm) & (f <= k*fs1 + fm));
    end
    
    % Yetersiz örnekleme ile örneklenmiş sinyal spektrumunu oluştur
    X_sampled_aliasing = zeros(size(f));
    
    for k = n
        X_sampled_aliasing = X_sampled_aliasing + ((f >= k*fs2 - fm) & (f <= k*fs2 + fm));
    end
    
    % Grafiği çiz
    figure('Position', [100, 100, 900, 900])
    
    % Alt grafik 1: Orijinal low-pass sinyal spektrumu
    subplot(3,1,1)
    plot(f/1e6, X_original, 'b', 'LineWidth', 2)
    title('(a) Orijinal Low-Pass Sinyal Spektrumu')
    xlabel('Frekans (MHz)')
    ylabel('Genlik')
    xlim([-15, 15])
    ylim([0, 1.2])
    grid on
    
    % Önemli noktaları işaretle
    hold on
    plot([-fm, fm]/1e6, [1, 1], 'ro', 'MarkerSize', 8, 'LineWidth', 2)
    text(-fm/1e6-0.5, 1.1, sprintf('-f_m = -%d MHz', fm/1e6), 'HorizontalAlignment', 'right')
    text(fm/1e6+0.5, 1.1, sprintf('f_m = %d MHz', fm/1e6), 'HorizontalAlignment', 'left')
    hold off
    
    % Alt grafik 2: Nyquist örneklemesi (fs > 2fm)
    subplot(3,1,2)
    plot(f/1e6, X_sampled_nyquist, 'g', 'LineWidth', 1.5)
    title(sprintf('(b) Nyquist Örneklemesi (f_s = %d MHz > 2f_m)', fs1/1e6))
    xlabel('Frekans (MHz)')
    ylabel('Genlik')
    xlim([-15, 15])
    ylim([0, 1.2])
    grid on
    
    % Örnekleme frekansı ve tekrarları işaretle
    hold on
    for k = n
        if k ~= 0
            plot([k*fs1, k*fs1]/1e6, [0, 1], 'k--', 'LineWidth', 1)
            text(k*fs1/1e6, 1.1, sprintf('%df_s', k), 'HorizontalAlignment', 'center')
        end
    end
    text(0, 1.1, 'DC', 'HorizontalAlignment', 'center')
    text(fs1/1e6/2, 0.5, sprintf('f_s = %d MHz', fs1/1e6), 'HorizontalAlignment', 'center')
    hold off
    
    % Alt grafik 3: Yetersiz örnekleme (aliasing)
    subplot(3,1,3)
    plot(f/1e6, X_sampled_aliasing, 'r', 'LineWidth', 1.5)
    title(sprintf('(c) Yetersiz Örnekleme - Aliasing (f_s = %d MHz < 2f_m)', fs2/1e6))
    xlabel('Frekans (MHz)')
    ylabel('Genlik')
    xlim([-15, 15])
    ylim([0, 1.2])
    grid on
    
    % Örnekleme frekansı ve tekrarları işaretle
    hold on
    for k = n
        if k ~= 0
            plot([k*fs2, k*fs2]/1e6, [0, 1], 'k--', 'LineWidth', 1)
            text(k*fs2/1e6, 1.1, sprintf('%df_s', k), 'HorizontalAlignment', 'center')
        end
    end
    text(0, 1.1, 'DC', 'HorizontalAlignment', 'center')
    text(fs2/1e6/2, 0.5, sprintf('f_s = %d MHz', fs2/1e6), 'HorizontalAlignment', 'center')
    
    % Aliasing bölgelerini vurgula
    alias_zone = (f >= -fm) & (f <= fm);
    plot(f(alias_zone)/1e6, X_sampled_aliasing(alias_zone), 'm', 'LineWidth', 2)
    text(0, 0.5, 'ALIASING', 'Color', 'm', 'FontWeight', 'bold', ...
        'HorizontalAlignment', 'center', 'FontSize', 12)
    hold off
    
    % Grafiği düzenle
    set(gcf, 'Color', 'w')
