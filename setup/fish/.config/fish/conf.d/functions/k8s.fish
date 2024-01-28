
function kctrl
  if count $argv > /dev/null
    set podId (kubectl get pods | grep $argv[2] | head -n 1 | hck -f1)
    switch $argv[1]
      case cli
        kubectl exec --stdin --tty $podId -- /bin/bash
      case logs
        kubectl logs $podId -f
      case pf
        kubectl port-forward $podId "$argv[3]:$argv[3]"
    end
  else
      kubectl get pods -o wide
  end

end

