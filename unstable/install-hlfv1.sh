ME=`basename "$0"`
if [ "${ME}" = "install-hlfv1.sh" ]; then
  echo "Please re-run as >   cat install-hlfv1.sh | bash"
  exit 1
fi
(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -e

# Docker stop function
function stop()
{
P1=$(docker ps -q)
if [ "${P1}" != "" ]; then
  echo "Killing all running containers"  &2> /dev/null
  docker kill ${P1}
fi

P2=$(docker ps -aq)
if [ "${P2}" != "" ]; then
  echo "Removing all containers"  &2> /dev/null
  docker rm ${P2} -f
fi
}

if [ "$1" == "stop" ]; then
 echo "Stopping all Docker containers" >&2
 stop
 exit 0
fi

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# stop all the docker containers
stop



# run the fabric-dev-scripts to get a running fabric
./fabric-dev-servers/downloadFabric.sh
./fabric-dev-servers/startFabric.sh
./fabric-dev-servers/createComposerProfile.sh

# pull and tage the correct image for the installer
docker pull hyperledger/composer-playground:0.8.0
docker tag hyperledger/composer-playground:0.8.0 hyperledger/composer-playground:latest


# Start all composer
docker-compose -p composer -f docker-compose-playground.yml up -d
# copy over pre-imported admin credentials
cd fabric-dev-servers/fabric-scripts/hlfv1/composer/creds
docker exec composer mkdir /home/composer/.hfc-key-store
tar -cv * | docker exec -i composer tar x -C /home/composer/.hfc-key-store

# Wait for playground to start
sleep 5

# Kill and remove any running Docker containers.
##docker-compose -p composer kill
##docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
##docker ps -aq | xargs docker rm -f

# Open the playground in a web browser.
case "$(uname)" in
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

echo
echo "--------------------------------------------------------------------------------------"
echo "Hyperledger Fabric and Hyperledger Composer installed, and Composer Playground launched"
echo "Please use 'composer.sh' to re-start, and 'composer.sh stop' to shutdown all the Fabric and Composer docker images"

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� QSY �=Mo�Hv==��7�� 	�T�n���[I�����hYm�[��n�z(�$ѦH��$�/rrH�=$���\����X�c.�a��S��`��H�ԇ-�v˽�z@���WU�>ޫW�^U��r�b6-Ӂ!K��u�lj����0!��F�������6�r1��+D�`��k�帲�זۚs5ޤ��ShC��Lc,s��@��)�Y�( �1a��o��pè��!7�Z?�DjM���]�:T�Ў��C��Z��:^� ���
�¬���I4ښmMh�=�d>[ȗ��Q2��Ȥ��w~ ��_ �*��-�M��U�`�5M���zM�ښB��P�Q��RǠ8�W����(�f�"0��e����03��E�~�mv4�vwe��6��4�&�x$ܨ)!�r�h�Z�-��2�H�i��F�E��#M@R�lSQ�-e-�Ӈ�ܴtFd����G�^���EiȨ�H��n��Vӱ2)����l�\�P�1�wIy�u-D�"�*����ջ!3��O[�qwJہ��y0a�s���QBr�m�I�������b/Yˆ**Y��y���զF�%��씥�h��=�au�ɢ.��vL���_ZxB���6d�'rEܑ�Kݷ�~�uDH���h�F�<����U�?�����8�������9%c�#�����e[5;�7A���m� ��_��,���g�<��<����<��W��fD��Ӡ�e+�O�E%T�Ƣ}�K��ͣr~����0o/h��_����"G�)�i������Ǽ���^���.�������%+'h9>vL�N� ��ؕ������q1����X�]��< ���+���@V^�o$�(L�	G��a��-h�2	s�kܲ.g�`���?@ʹ�j�u��f�:.�Z6^{�X�֖]L�k� 	�[nô��*��)�pH�D4�0�y'�����"�N�r�4d���֘t��[�J^R��+jA�f-` �5�"�]Ct��Pu�LH֭��-����ca�8�g�y��^B�Դ�́��-MWC��4�6!���t�B��c��7\#8 1�e^��Sc��1I����%U84T?׼(6���(��~��PL/MW��O],��Y����"��U'������B���o.���� ky��2�Q��'��amæن(�e�Q��p�~"�5��ϨwU`ן<U��B��(��`m��"�u@���K���$T&��Py8o;Z���w �l�h�:��y%:I�TMC�s����ҹ+K/�J����X�	H� T��^�V��7�l5�K� ���跘�BڬpI���9����L���:�5Lu�h/�4�{|�?0�=5L#�7��q��ͦ�h?W����(2�K%��>:7}3��ű�U+T{������-�%�0���>�n5��C��u��Cف��:T\�ihJ�D����>���d���ilH��A�osF?������m~o~�O/ޮ.�	��۩�xFX�% U�'/_^"��G����hBg��CGV(�4�br�a���ѝ�~0�n���b�7X�>n���}yGeL�o��?����<)ui~�43��@L3H�Ӈ�<��٦NSX�M�r�S�Z��s@Ri>�ݥR����	U�̔���R�PY��&�'c��}������ _,c���:G(e�G�R���瞟]\�̾�;� 4��/��� ��a�%0�`�wС�����D9����(D,^���[����Q%���;���@G;˃�D��:�F�0�z��:`�І��?{ÄV�>B���_�7o�����<�!x���#D����5�Cj��V�
m|�5������iq�L��p� �͊~t�q�-B�B�"������\�[���q��f��8&������ㆱ�?�v�r8���,3���ĉ��w����j}��	4u���PȲaM;�ye�'П�R��0�����ۗ1��g�ᅅ��<`r��n1&�������?���a����[����C�.����������Wᦁ���hۦ�X�f���h�)���
<����76 �lˍ�Kv�Hޣ;��6�c����&�^C�.u�<#Հ�,D#��Fo��9KL�n�"��5f(:��߅���3�q��[G����y5�;�F�M�k��p���Y�����ϥ��"ߌMwy!�����s����ό�?�-����|�Q_h����q�.�1���9���p��W�y0�w(�lE8b!&̆�^*\�ԉ�������gz�������?�N�/�.�^��=���х)`���K���J�:s������<���a.����O��۲��|��l�������ۂ��?�#�?���?��o���W��<o�1�̺G%�<A�Y3�@)���H��ݬ�_��Cs��&p�K�hLb���Ye�����9tS������G��!���O��>6[�kp�=ܡ+d����g�����K�BK7�{��V4��X���ь�y��,���
�i��<8���Qo�5dT!4��V�#�#dd��P�G�q�0��gXݞ��	��a�O��-��<�Hv[�wߌ����x��^!��%W�ޥax�����'�JلT*�v�GI�HD����ؖR���' T�b�'K�q1�ʩ�@K$e0��!\0$J$��8�C �/IGI*��TI*�ŝJ>%U�d��D�͢��
�L���2�3$�#mَ�-�磰���l���L.}�-�J��))��)8�ZG-2\��I��
���@��N�]�{�<~YJ�2���N�����F������*a��%�����[�r�eU+[׌�~��� t ��eG���K��
0Lz�q/�M�Մ�|�u�ڸ��f�;�Y�7u�h��	����B��>x��=��$w
��+��P.!�B�8= �X}�N���j�:��~�l���m��%>�<��o^�,z�d������x:�go�4��9�������c0m���R�I��s���h����u����� �=�E��0�.�5n ���D.������)�`��<l�<pq�g��K w�(X{� !��_yw�u+�=p�0���ͥ����؈����>\��~s���^���U��<)�"� ��������oP��RjuL���Z��ͥ������H,�����'+�䖪�Vo���'B��.��Z'��<�����
��������q�s�8�X��n������i���t��RL����[ ��P�LB{`7|��` ?J��	���f��=���L�
>�N�O�?23���w�K)�
���_��p�[~^eط�ʗT.n���#2������$c�C����U���ڹ�ݚ�^�	��C�*|���v���A����o��@��n�e�����;���=q7S���Y��|�����i�2&��ph����-����;���OQ����3m��q<�����kh��d��w�B���Y���p�C�w����j,Ct/��PV�:_��Z�r1����Z��6*(�㘨Z���9�[a�hM�)UV��**B����&cQ���mW�i
�;�aHH�L$�R%��I����L&�u�L�j�.v2	��)fv��f{�xU`O���Z�g��V�^?m���bJ<Nt�E�sh$����b1-u^��K�,*Jdw�d"�U�6y4yk�"�eE�8��v��VF:��{���:w\=��	�K����WF���0��*�3}��kW+�8♇s8K��,w.2���Y�X��*2
�zab?,�ᜡZ�����nBܯ��n%[�v$�f�c���ά��j�����~gC$q�R������F�xը6s������Jg�K�J%i֪�$P;(g�����۩�wZ�ܪ��8�H���Cc�<Ȝ3I����SbQI뢔j��Ս�D��Z�󺼹�׎Yn�a����䡱�KJvb��y��:J�؎���kc�p�wv��A�|�L�xAɝl7ۂ�Ӳi���#ZKL����������W�&����W�b6+��d�I�ŝ���!qRGJD:�dV;[��ԡ��9N$���)�M�k����S��p������7_�Ȧ��Ze.���r�l��dݫ����-���*u�NI�ԫ�閹eo���i�P��q�Oo��6^>����5}U9�Z�̤�ʡ�S*,&�~uuu�9_=;�h;�K�W�S#�>h�ϙx�}h6�r�1�A_\\ܷ�Z���p$��iԷ5�}������eX�n��.� U����D� ���4���&���������!���}�}���	�?�A�����q.Љ��.�����OBQ�LzS�K"���t9[E����w��D���X_.�ef���$�X[�ً?�l���Zy��.�2���\e/_�K�W����K�b1c_9{E��\n� �J�Œ#��:��<��X��U2��z��H�jIIo'Ο+��mUrP�a7W*�	��ͼ�H,�����k4���V�p�Ø�c��?�����6����]�<�0�n���������Nb;�N��A��GT� 3�9������)��V���������gS�1���,?l���?��_}J���>{��>�������!�y����)�^��<�����8�aUUy..Q���8c�JMV�|Ma�����"�+����� ���������o�����_���������=�7�b�W��yH]��_zF�D�,��5�X�r�'ԏ�v�˖K�,��%MQI�pL��Zͥ?[Z��(G���/�铥��d0˳�>�g��K�Gd'�Y�b�?�t�����!��񞭹�O��d������J_H����s����o�����?������������'��+~v��K����m�0�y�����op�����7]��2�v^��2E9��$�D��S�wF���c=��30�G�C�'h����Y�@W�����c��ҮT�_9e1H-�\
����{
<����e��W�PH3#�H)�ªi���DK���"l����	�Ζ���m�d�B���*_��Ga��	BMQ`�U�5V��j�[��j�Z[�Xlʜ 9' T�\����V�T����s��H��Z��+{b!�(�9����w%1����O&5���D�,� Ng�L,�p)��F��(��$.�D��W�Z(�RQ�i9$p�\�,F ���N� �f H�8v�!@�A�C �RRU�J����K�i�����E����-�{��4����~����2x';���[�"�U*ڦ�?u��zq���2[�V�%�c+�D����^��O��ي��VV-#%�O�.�N�����*�*�h�xk�X޲���<���ȏ�*�ȱV���ۿM�c%XdU�#��J�$�s�	��\����?������t�a{�Ñ:�3�r�9Yg.s�j�?<��O�l�xo���a;�
V�<����q�$�E ����=��[$J.~Cm�~��U�'�1rٍ���I��'޾Ʒ�^��/���p�_ؼ%I����F��K�u��Kr�9Y�d�BW��;Ü�홥�0k�0ş��J���H��}�&�n9��.��$�vu֯�?I����z~�t����B��k���/�^�w��d�]'������q�ɫ���حq%	�a<M�Ą�fg���F*�:=~pc��*��_�P����<��J�*�B<�����ǫ�o��e��\Y!v��!�"e��Tc1�%�t�Nju����G�������Y�<�'y�N�ɇ�����Gv{�6í�
����eӤ���d�<<��vx7��$��p���֯~�~1��50�Ǳ�}2�ی�E?��$l������/��2ǉĝ���d��u����FVr����8~&`��)�'�������r��2���_���[!����~��_���_I�����
�G��W��߇������:��i�7�ԿՁՁԁ�/����+���$V�Z�o�P���q�m�20��Q�eq��Y��i[�
�:�(e𬁡9�cG�@��@����Իu�Ͼ��_�~���O����o��_�_��K��F�
��J꟔��< ^;���������D����Է�9����;���6�����z;��R������rIn0���M�~�,��?�3H�sƅ�4�x��j�I��*u32�dw���hU�윔�9��Bw+���u�4i7�i�#��c�¨�1�� ���hHo�!ĔS���WX.7k��I����M*lɘ�#�����0E��Q#�0ř�#��#��3o�Yt�GE@��|�g �p�I~3���j]��BBE�*���G@�r��W���Ը!������I�=B���~����!�{��L4�����JXm^�i~ؖ��P��,��e�o2���#[���:�z�H9R�7	P�3�6O�Fb(�L�@�6�R
�$9��]^�]���r��۳`�b� ��+v�h^%L{�!�ce=����m�\b�S)��']�e���n%�֧N!�����DI�2Z��J>��Eچ�.��A��B�Җv�Ȏ�<��9(S���*Q�x�I��lR��|Ū��dUI�rUE�������9+	$��(*��3��&OdX�y�F��2�8g?�HE�؈�V��d'Zu�$R�\C���� m�݂�!)��l*Wsr�����2��N�2�e�iT�к�G�qvЍ!'=4ߑټ�EX����H{�G����D^H-
��e��U)Jc�yq>%Xj�@q R@�sr�d�
(P�A2���	T�<�|�w��p@�c��I�!�N�	��3t�+5IG�p���4�7�f���5��	7����8�sҝZ���aK�
�	z�ܠ�F� �$�1x��a��N��}F�r�)!r�~4�;��V�c���|�E*]�Du����h3+��Rz�����dT�h��>O5�|j�������:�d�B�=A�=��F�xApQ%�A��!,���^(,�Q�d����y����0h��\=$�p_ɰ��!ᅰ��v���!:�J05⫝̸���}��F����Jgj�C�t.��>�R_ߤ��i%p�B�u<�M�x��V� 7-�nZ�ܴ��ip���;�,��e�@"�W��~�ڊ~:�����/��z'u�z%��g>w�Z�y�2�O΀O6��~)f���	��6���&�{�׻��Ny�?�8ݓ���ߺ�4�?�����ԟ�;=x��.���U-����DG���^�3�N���u����f���1�7���I_S�^�K�r}&�aVo�T��ײc��Q�0��I�XE:�-O�H͇me2u��9 �WJ�Ҙ�jCD��m������-[�!��n�\.�Z���xh�����a���{!6�Yҥ���Y� m����Um��l!r�ltGJ�^h����):�G:]��pM���y���C�	%��f����\�n�0p��g�bI�)L�}ɪ	u2� r��[bv�b�ǥ��`��*v�T*,ύ��&u2F2N�m�l<y��jE�DՎ�2`�͈l@f�`�1A�.7�n^�%$��A37wM	b�m/T{�y�X��L�H�Qx Mi��r�(�1*'4�F3?f#s���"K͌k�P33~Xm�Q_T��4��!�'f�C`���t�%X@�XM�қJ~�T|Y�R��B�����4]�*�NṩX�IU,�*٢bA�-z�uG'�c\P�{�1K��z����g9≎��tr�žE��ө�|  �y�������Z��R� ��g��J��$.��*�"U�Q˥���,��P�3��ny�Zq�R>V�4rn=Jb�:˵�F�T�V8m��*����:� k�Ư?�
�}���M��B*��3V�]�N�\��()ޒdt���~g@t��^��t��Z0 b����4y,IN���N�le
���{*:��>V�\����TD�F�9YM�(��R�&�g[����ۣ���'56��$���4���tXz��$�Pd=Ɔw��p���[tD�^�hsH�UD�N����	�O��,`Z�D����y	c��$��!�Xٙe���fʸQ�FK� Y�)F��I���rq�6wzT�����xP�$��Vt+z��� ��igL>�4^�+�%F��%��xI�[��(*���j�z@4y� [c} 9����3�Od#���r�>խ��4� R����d�n�z*���68��Ks�h��~惖ջ.S��G��
y�9WQB~��	����� �����	��$(q��6^�8p�7�~�adI�M�r7]k:P���Z�SԈw�]M��&0o��Al�U33(�]!�T6�|��2V��QmV1���d@_�Th���w����}��>��ϱ�V���Ѫ�X�j�{��=����׮��B",Fu�U�Ӛ��.�h4d�	�M�i�;�}���8�8��?g^Q�S{DХڢ<��̃Y6?�J���h�(�vP���N�R�*�D��Z�j�����w[`	j̔A �|��5�r� jޏ�rw�!�Y��בTXGR�#c���BW�y�X�X�. �q����^��#v���}B+ֽj�$V�hd�����.�] }ui.�#��H���q��R�0�������GM�tI�&�W�q�Z1"g���T�9Б<R#�����
�2��(��/��:\�2��z}=��~�q���'!'!�k�s��e�VM�
�#w��<L3�
p/���$TfC+�f��������%��R��ёݹ�z+����'�|~��O�]����lڝ����?�`P�$V��{��ιj�u���y�\5���p�{�������$Wm�\sY�|��N��}��Xw܁C�?f��S�$�{v�?���6��W'����X�ǣw𓘾p�N o��4͑�V����!��j��H��5�d��-^Tz��/�e׺Ǔ���`pv���6��Y6��O<�(� �~�o����o�M=���(���6�N������о��m��_��Z�]�=m�ۘ������t������e�=����_P����������s���M�����6h����D����{��=������!��d���Aw�;r_�7u������K�?Ùx���t���Vh�G�ny��(��>
�^�χ��o��f���mЎ�?��w�wJ{��Ŷ���g����;��{�Gt�A7�����o��� v]�������%�Dt'�?xc���{��6h��_���}`����_l��N����x���Aw��3�� ϙ�����M�����AW���EV���/��a�By��͸!m�h�G�Q�_���-Pбo�X����e.>p��O�msP���Ix���y�����ԧ�U�!���Q��举��]��WeR��v$aT�ҍ����$�~78����I�� gڣ���h���`��N�J��A!;�A.����;>ʦC�J�ŭ�D�`�������c,;�v��CT�S5Q,�7�B��z���#��\Diͯ1N�(��R�����W��s�����k�˺��z�>{���a�aYlo������Z�p쏬���#���/��w��3{�GtW��2̜M@�(�!&ff�,nY:�C,�u[og� `ԶsmH��l.�c�4۰I<���~��.�?�Û�?���o�����TTcO�>�j��?W��N겝f���vE'=n�js)�
]� ���+b�f�E7z�ʜ�#rHw$2y���kZ�y8�Ge�>��TpN�2��%G����wfM�jY~�W��-��� ����L�t0�8�������{�^�5u%�D��"�L*#���^�쳎}=ʋ@�M9�]n�h0*gkw�����Ը����?���Cc`�i���3px�S,������Fx{�O"0w������Gr��� ��'��`���X�Ŗ���G����������o����o������꿈��(g8>��(���"��.��<I��J���":f�$:��8���e�,����o��U�����F���a!�;�D�b�vH�ۜG�if~�C?�][���?�����F�g�.��	��޺���򰤫b����l�:s�x�I���ywն����E�
�k�͗{A��{���O�������S�� �-M������p�O#`��<俢����o\��G��4�b��?4B��1�Xє��h�7�A��	 ��!��ў�����_#4S�A�7������O����ߍЬ�?�����?���C�w#|��+�c�����U߿ؚ?�zk7�6e�����X�Շ�k��i�ۮ��Z�a�z:��k�|7�Z�֟�������]���~Ǽ�1�դ�I�e�^�S����r��%g���)�%�p׾Tû�([��0��e�Ga���f�>����Ѻ��y�u���N��k*�/�mߔ����ݕ�-�M�%Ժ]�v�lʞM�ֶ�#��;��e�Q�T>|H�,��T"�����̾�Oz�ݽ2i�*�>t�3+;F,��P�
^�D��3�D�X�����%co�$�7#�0������uϱd�PyA�t�}e_��p�*�P�!��������P�5 ��������A��F�?�8�C��?t�q�O�E���w��r���;��>9;�v��*iۖw�S^^w�@��mO�S�G�����&��bc(��X�Q��uÝ�ל��Ə��dkmzU�6tS�'9a���[��lד����.�˵����XY�c�n�:g}s�G;ɭD�M���n�jÍ������-\n�+��2���1֗�n��W�������%�ˎ<���{����!���p��������p�8�M�?� �����?���?���v����?�����S�����'�&�����#��4�b���o���߽�M=�~�c5�������b��_ �o�������G����_�����A4��?�����_#�������������������B�Y��@&����߷������?����A����}�X�����������������Y����[�������7f�E֙M��nm���@��������M����{�h�]�k������i�Y/kO���Ɖ}?e��6;�����ː��Ѡ�}>�������P9~26gw�]��ˀ�ꢲ�j��)��$+�B���������_U?8�/������Y6;�N|�<[�C�������1X��)KI��)\���7n���xZ~�����3�,�YT=�Ri|�{�/�i�隴Z�����šPm�?'\r����aq�������^�-}"�SΚv��,�F�<m�����E�G�8�����	���Zw��?"������g^���o\�?c�\�%2�D)f2�!iĥ� ���1Ee$+2�@�Ȳi,J4�r�$Q��P�������������������?�����������_��]��fE'������Z^�8rXpƶC�7�$���ک�)tŨ5�-֓��\��#˶�9VV��g��ަB�n����b�����	/tg�醜{Si	�z�z�W��9q҅��aM�6��:e��pOo
��8<�!�M=���F?�������Ё��C�2�?� ����C�2���A�?�����������P�!�� �1���w����C�20�0�� �����?�����!��?�� ���������@6�����18�����������F����?���Y|��mj?�B#_p���7v7��L�?��ᛉ��8?�!�/��nM^F7�4���,��h:��]?�&��٭.D�&>v©����m��Ƿ���R�K9�H�x�^�vXw�_�i55}vN���"ތʄ�M[�{���*3e�Se�R�Arn<6��:��SHKG����:���*����r7̉j�eM=����RF�8]�y]N���lY�Yw��-/�=��h�غ�����v(�{���*\�dfc������V�͙�FKS�ku~�ImrB<�"?��?t6}`Y��x�J�-�{��)���}�	tLY��:T��w)��U�w�|���#�����ד"�c�v�b�;��'�n��h�w��M%�SWI�k����<����8tO����t�T�}ݥg��j�\K�>.I��W�)��֤$��s\�y�.E�\9YR��~��gg�F
���b�,�?��@���?��}�8�?����H�Ny�J�,�c��r&�x)�"�b�$�Y�dҜ�%�&3��Y���<ɓ�J�L�������t������l�D�9u}� ���$6C�H#2Ldz���n��O�֘��oity��Y[U�~RF��V��.���K�i0�;��O�D*�Vr>��(K��:��m��f���}�u��%�|/o��O�-��'�?����k�?����6����?.��}\i��������&�A�!�M���o��/�C )������򿐁X�!�1�������{���?���o>���
!��є����/���_����\�{����&�+�(��@E2�����ߧ�0������o{xK�y$νӑf�C-ȵ���Z�lV3'/<�C"�g�ji{Y8S���U���S�6��t]v�} ݖ�MjnT��5k������<��io�� �jk��}�Cɭ����fpI��c��?��*u�ǉX�)���~?�7�Tew��X�LW�Rs��n����5Q#�Qd���޹�t�c��4R���L�Q����3�����m��_�@\�A�b��������/d`��`������������[�߾�-�k�0��t�M�2�;�,�$���=�_O����6������Rw�4PH�,���tܫIUB<�y����iV�{T:�!L��Ӌi�u�����Xך��!m�c�_5Ϸ��i"�Kѧ�;��V��k���~����`VPSٿ��%�^�j�H�s�WOVM^*t���F�]�-��n��e�z�2Ъ��0]���ڎO��<+��j�˔����ȮWjje/�KlM���V0���m��wi`Q�A�2���������B�!�����������Y�����&���>�S��>��3͗�1�R�:�C�7���/�����������:)���,>�U�ߝ�T�V����վt�	Kmv�|���l��9�=�<&\*s��T�9ūǽ�{������e�Zr5)��i]�N����'����������ǹ�/������Y6;�N<�K��Vfǐ��ȳ���e��n��L<S	k�.�b�m�LN�>�u�����#�s���N���݉��E�ͥ�E��2;�=����]Όr6=��2/iݟq���Y���to��}�:���[���Kv�RK�]�9U����.��� ���?��B���]������\�_���SFbH��*SA�r��#�d$2#3��bR���K4Q<�=r�H:������������_��+���p�Du�a�Y�`pu|o\J�y���nlN��ր���e�wwjMf
#�����{=�5����t"� ���:ݥ�չ��q0��l'ɗ@��B�^����]�����d$���f�$�}/8<�)�~���w#���'�;|i�����#y�M����S0����?��bKS�������	`��a��a��7��X�M9��3)ΥLHEI��4礔���hNs�MHNL��JH���c2M�Ϡ��f���_��)��i�_���f�M�\��J����F̨�Џ��d[�<���[d{s��}>���5�N�~;l�Vk��c��=�抖@��N2�E��Ӎ�5��s�4C����Xf]M����luuVT��z��ޅ������b��?$�5�����*a [���?��g���F�B�y�EE3�1߸���Z�i����h���b���)����o��m����o����o������B�����+���w�������hV��������7ˁ�o����o����o���0���f�?��������A���t4�������[���������?���������7E�>��4q���s��������4�����᱀����O1��/��7b�������G������o|�VQД������ ����������CP���`Ā�������*0�0�� �����?�����a���?�������B���?d`��������o��!��!���q������Uv���C����w����3ԋ�������s�$2i��Y�qt$�R,f�\�Id�dL�2	�$�@&� qq�p$�	�������z����78�?�S��/��o�/����{w��/C?��'�5�k+͊N�ѣ7`Ys)���c�Z��d��_�~�����A���Ea�w,�_�Z��T�'U�I��ջy�H*����޽�ڹ��;f;:b���]4��i��8�ij�ِb��k��x�]0O���gΦp?e+#d�	�Z���	PDZ)�ԃ=�h�YGx�h8�So��*1�|n���Mѱn��U����=��_�����ں�/��� ��w�����������c���?�����t���?h��}���?�����0��@���?���1��������?:CO���� �������������_��t��?����������|8����'H��)��6�f�����E��k�,U^�g;�
�����a�uV��F�GXٛ�W���e��4O���$�1�\y!I�;��R�i�̗�Sf��y�����(��㍵ic��T���6�ü~EC��Y�:O��p�/GMIh���{�&����R��\�e.�ؔՠ#�rI3O��Et>i�l��]k�v��NnȖS���m������?:C���t��?�����������!�I�	<�b��c�����#�l�C���0ѡ�!���~D�19�����>�?����3�Y�����O`Ru�S]�?+V\gsخ�tXo?��ɳ�ə@LVO<L��Zt3l�!d���8���g�4�T�4�2��b�y���h��<���k���^�����F��)������B�(�m�O���|���G	����?���+�?���o}�A��?���
Z��G�F�a�
�t�8�DC"�i/�X@1ߧ����P�	"�H�����X�?�6��_�4���
~��Sg��s=;���P�2�1�ޔ���*�	�cr����h��)9����Y����
ח	��������E U�	e�9I�z�D�x~r���E�%�MJn�*奦��^�����w����%�������h�����/�~��[�[�_�p��*��M�Y]2On�#��b��:1��n���~���H`�/�_<�]���7b��X%6�?[���������/�Wz�^�|A��5�����em�r�/-k���j��]@\|p_��T�k�P7����*��q/���:@c�y�bU���Fҟ�67iD�o�g����8�/�W]���5�[�ıˆ�5�]����N��DO���X�V�\ө%�\���#柒���Ά�w|Q��O��^0�T�3���M
�"�{�T@lfa:�EP�|�P��F����d�m�F�'�9�w�ٮĚ�D::�T��,J���#��i��V{���h�m���z��A�C+h��B~�������0��Z���5`�D�7h��x��ߝ����ko���o�?��U���ݣ[�$��H�`5Vf��?���?���S4�e�o�e����|����YV)���	�Ψ��h�M�Ț�T��q9ɲ���j�i�p��ኩP8W"�_��r��w"����ϋ]i�2�eN�%�|F��.^�̥(��x���Q_���˪�Y���4z��2;��5��c�To��e9��5
�)?�[ƙ,��=�5�9D���0��s~>hBVu~"����Ҁ�1�����`*[�����gT��\�V6e��
#���;�$�t���h
Y�1#&����������G8�y}��7������V��������l�����;����!A�	��7��ݢ�!���6�������7���\$w^_����2/mMs�]�&ȟ�w���^�w�.�F���9mw�|�w{5ڟn^�]7�k[��-�GxGޭ<�� �/�~!a,�d�"�lh�6~�}7Ȕ>U����:�/����.o���|�6��"�DKی T�3+㾴i|ɶ���s�<��/�>2�8G���Q7PÝ��� M�%�cvD��*�|1Ȏ�y��s�g?}5���/�	{��茟��+��aTqw���*]��4�甴���"�Td���� <槈�<��ոL�5��{36u��ftI~�����@�oG�T���9�����	�6�V�����0��{���MR��0�R� w�N�?����pwQ��?����pw�;����8���!�Fc~k-�0�K{ad$M��G�;��4G��Z��̞1"F��	�{1���h�U�*�U����Q����O�A�sy�H���-v�.3&�OeZQ2��xS*���?LX�ݴ�Q��|�$s��-Oɸ�<L^��e�C�TCȦ#�>FO��ȥ+Xu���ȯr��I
�BB�1W����1��E(��_���{�@�����_`���՝�{���ZA���~��>�?�zP�E��ko���V�MX�e��؛F�*��]M7Э��5`�u+7$��UY�`�3u`�|�~c�5BA�˗�l �>�M4[��'s�amK��7.z`���F��-�e�PFp��Q�e�:�Vg̟���J�$2�w�7̺�N������ѵ�}c��:��oW�`��io��*AF��q�4[X��(�c�����xw�73���Q'Z5u�B�<K��$)�{xF��#Ȭ ��F� ��~��_@�w+�J����A�=��	���
@���O7����t�N���s�A��������?��4��z�3˧�(��B��A.�˙ƴ<�ݺ$�7<���`7-��_|ݝB���|��ʜ��k�w�$/��9����s�~��Q�j��%U��1$��J�k�6�s��.���9�1>�@�N�A]F|�Mԝ��e�00r��ł���f�����%^-�r��O���LJit��]���FM��)��<����������=���#�q����?� ��c�>�?����w�v�T���>�P�����?���?���G�_I��������ۗ��Y�+������'���A/�������h����>�;BO �����!���/��t��`'\? �������������E����\�������
@���@�����?�m�?�� ��c�^�?� ���ZA���� ��c�?������?����M�f����?������?��t��w��s����?����m�-�?���`�j���ݣ[�$��H�`5Vf����S���������ϙf܈s%t��ܻ�9A_�dY����'�:�2L��=7"k�S����$��:���e��2�+�@�\�l9'���މh��S�>/v���,�9�<X�4*v���ͥ(�[�^�qR_�qb3�U��K�Y��2;��5��c�To��e9��5
�)?�[ƙ,��=�5�9D������UE���y�E���4�k�sc�&#�ʖ�%d����+��ՂMYj����N=	$]`�2�BVl̈�$�*~0w{��E���[��C係��VЕ�ˣsU���n����}����?���t��Q�Db��P1��8�\*B��~4GC$0�j� "����_��~l?���8���?	�x����ĺ��O��|����jE�%os�x��]O��M�ԗh��J\��A�Tu�Ц)傹7som���G�a�عX��Z�O������f�w��T:!hOQ��e�4��-X��g|�E������Is������r��h_m�ݓ����p�G�;���-�O���@���h����������^�?M��?��h������B�z������}0�	�?��S�!P��?���������-�/��@�A[�����(�����	�?A�'�������/����N�����l����� ���@/������� �	C��o �	�?��'���m�������
:� �s ����_/������ZBO�����$����_9��n�f��r���_��vIp)�h5<s�bc�������������F�򭝴�`kl��uV��=�Q~�����ȳ��
]� �z �	+������W���|8��)I_P6�T����0"U�̀9���6�j[�?�+	9�L/�5�t]�پi�v��Z�Jl#$ϖ}~���lb'���Vӟ��R��$V_�����<��ŗ�^�:r���g�7W��l��x�Y|����_a�.��K��P�y�-)ט҄��
���Z]=�)�d�e&8��`�0���#����M�
����|P���x����A�gG�T��������}�}���[A?�?b<"=/��(F�!FR�Ø�"�$�
h4�邐!�(��q��FXH2��U���?]�����'D��ٔS_TV���S�sH~N���Eu����9{�9�i��q����2O�_�H.7�������Lf˱�N��}&'�P���oR;��ט85�#V'�z�*�?�����⽟�ۧ�=?�W������?J�ߝ�a����?����{����I<���b�)NU�):����]���l>]}����/���O����=[�#�U;3�ٞ;;�C�ݙ4"��23�fƮ��l�^~��v=���P���lW�]���j��@�(!(�H��O�J�$ VD�6��K�~ �	i��Pew�ݯ����C�OK���޺u�{�=��k}���vl��c�x8�CL��j��g�*�ww^�S�X�V8J_�_&p�pO�J<I"����>��q#�Zx�
M^;xeg�| �\��o��nǑ�q�������;m;�b���9%���c���{�f���R$b#7����rT%��5���cAGwbñ�X��)���>9f��X��S��b9����=A�y�Xd�$��՞2����m}�k@W;n셗O�}�=]�N�GG�p���QG���%����4�CVy�^���{�*��Y�V���v�`�Ed��+�k�X��Gj�s@�x��� ꆽ�[�;1Oׇ�;G������1�vc'�O'�D������7{l$K{e4���!=J��6������Pv�0������c�d�N�лs��['ǻ5�,�ة�DF��Ia{�D8��7���� x�xԷ�o_�����o?�si�/�gt�EU=�P�zI*z[�P$�`I��FN�I�P�6j��6�P3zR����@1�dƅ����o~-���ï���������oz�@o��{��B�q��Y�b=mC��S�X!�AO�}�_�CUA�K�p��}�g!\�qP���s�o�;��t�ܡ~�ag\\H�]��ٺ ���WχuOՇV8��гЕ��Ҫ ��uE;T�W��^g0t��&��������>�ɷο�����~G�6���Ε�x��]���?
�pN������03�=X�4'��
Kn��=��������_~j��{o}*����o���߸��?��f��LS�	}Oߕ����Ol��z.�+���h��<��Q(��ci/��aɶ��3�����Mcl(iCI)z:���6��$�D
K�h2���6��$��$`k��~]���~����}�O��;��ޟ���n�[}G�(B� B��	.��}�����_o@߸v �_��������򷞇�~���*�s�aqp!ʃױ�8x�a<!�=sT�5��v�M�X\�w</��88���Zsz|$q|�]����BG���T���kKH=*�e���&�r~@.c�y:(�Ҝِ^�c��pH�Wꭉ�G��H�Y�[>�HHn�tk֬��Ҩ��9�b	uٸ�r�;��͍_��S�'#��q~�o�l��<����Ⱦ,�5����of� ��ʌ��Č���N���3$e�}{e�b6����jů��
$�)��VD�9a�<��xk��.H4m�a��5�l���o�'D��"�,�]vhrA�VY���l0��� H��5�W3�1X>Ơ��n�7����؋�{���}��SD�h|�)7�&��[T��YaD+>/|��,�"O�%7C�EҀ�e2�3��N�J�m��4��n>�*�(O����9�ړ�*�I�,�*+w�cD�i��3KF����{jw�����Y;��nP��`�ây���E��ۖ�ĀwЪ�31�*�\ĔJ���bx��N 5�D������̶[�]v�S��io7�II�%�Q��&��ǽd�#�9���r��0GڲM�o�Ϥ(�x3b
��G\D������a�U�sN� j�����+q�����d	?�|w�pp܂���D�q~7��%��R���0珓-�d���*�s���+�G#���y����S=5��߯6ۮ��[�Gl
Kg�i�A��>�Џ�Y�2�aW��rf��,cuȸ`>K#���9yn²��F�S�-cr�V`g�Q2�iԜN�!�e��P4�3R˛��f�Yp���~���Y�^3 ò,�ɸ��jǘ��!�S��0L�֘&yl�#��^d���f%?��'���+��r�����Yfs�!�����%�2ռ���>ג��QE�b�3U���1��k�׌�[���k�(sXa";�<h�M�蠉��Ȍ*�HρG�Ez�8�.�Ǒ%�͟��$�w��֓�X>���6��3lB�������D��<6j\ڹ.Q��^���P`ꓔ z��S�r�9E�C�q�aj�)�1L�7���ے�%[UaN����n�?���yl�h"ۣ汁�D6�B&��?����jvig�B#��ê5��U�B����Y	�'���x�l��e��1���f5Қ��3�^N]#C5�^V��D�,R�$��y�����4&1�N���t��(���&�y"�<@X�g��BG�����[��$����\�"�mA���[Ol_��{���Z߄~>D��Z�+k�h�pp��5��n��R��홃5�w����������KW�?�rP�p㝟1ޫ�d�$vt1�f}�X�I?��0ދg1ޏ!}Ќw�,��1�3hR�m�"X;k�Z�4ca?�n��6կ�G�n'��'�L���\鈆0�n8�q�/�$��4� �K�X��r�C<�0މ�(K5�����F]���B�e�"^Iۜ���W���q��t�_��܊��9ob���������B`5h�����NulM��ͮ٨[V����K�GS>o��pX������q�1�X�6�~��k����l)e���E�>��*��TŞ�*�@/�U�T2�<!)�L7:|9Nj���XnN�20�Aq� OO`���$�'b~^%y$�rҠ��[��%�8�^�y7U,߅ej�w���I��=��՛Y)�ٔ�gS���YO��b�@�S�Z�kj)ׯ֋J��D*�#�K�23�̠�&�d���@���қ򮤉��V��P��<`RD-UiXm�$��wM�"��b�w�b�T�v<G.���:5�g�3�y�����X�6\��ڍ:_��?݅~t����b��[�߾���o܄��&�������)fs������'�K��P��g�z��$g��@�Cy����&��`������j��ٝla,�I`��]���R�v)VZHg<ۭ��T�!�����R��sj}���03h����`�:���`l��ɍ�����7!e�;���V�P��F�d:�>�Y��d�$\p�L�=�	G�&%��l�	��Z�L�*�f+e٢0f�۔;�歚�V]55K��ˏ���]FQdJϢ(3�y�*��M�����| �l���Ri���96q���8��[��O�o�O��j=�D�=��C��ͯ^l~���W/Nue&�����n���׼��@O�{����?��Y�@��f�����=�&�����.v$B[��ۿ�D9���}q���U�"x�w{��A��%B�����s��-p���o���ߏ�u��G���;A?=>�����W��s@�kG���q��s�H6��>9��F^��%��]Y�Y�2����V����z�c9&�3��Ӈ���{��o�Y�M)#e��0��E�qH�����
=��\ӆ���>�����w���_a<����6��l`��6��l�'�E�:� � 