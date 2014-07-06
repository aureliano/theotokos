module Helper

  def diff_time(inicio, fim)
    diferenca = (fim - inicio)
    s = (diferenca % 60).to_i
    m = (diferenca / 60).to_i
    h = (m / 60).to_i

    if s > 0
      "#{(h < 10) ? '0' + h.to_s : h}:#{(m < 10) ? '0' + m.to_s : m}:#{(s < 10) ? '0' + s.to_s : s}"
    else
      format("%.5f", diferenca) + " s."
    end
  end

end
