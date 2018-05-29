function chns(){
  CONTXT=$1
  if [ $(which kubectl 2>/dev/null) ];then
    kubectl config use-context $CONTXT
  else
    echo "kubectl not installed."
  fi
}
