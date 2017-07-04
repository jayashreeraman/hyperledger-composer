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
docker pull hyperledger/composer-playground:0.9.1
docker tag hyperledger/composer-playground:0.9.1 hyperledger/composer-playground:latest


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
� FG[Y �=Mo�Hv==��7�� 	�T�n���[I�����hYm�[��n�z(�$ѦH��$�/rrH�=$���\����X�c.�a��S��`��H�ԇ-�v˽�z@���WU�>ޫW�^U)�|��l�LÆ!S�z�h�J����0���MpL�/.���(�!�{���(�? ��-�mG� x�XRG��ƛ�{
h٪���en��lhuT�k�7&�5�鎤��:ҥ\�cI�ڒ(��3��A��H?>0��iX��f	@,�0+��o��A��Z�ނ��GJr�BE,�
��lf|�E ����V`]jkN��u(;�RE˨��� ���R�Re�E0�<�j#�`� �r8�ᖸ2w�&[�T�7/l�$�Æ��tB�r�'��+iǰV�i����p�.�J�&���-h��2�0#���@�
�f(�4IѶ4LE�2�H�K�gR��`���`x�Iz1�v��)�"��z�#X-�̦1N�j��JqC��t�%�M�1�4Ltl$�@��W�b��Ԫ<mC��)o���T�aRGG	�v'M�Gt�>����d-*�dU�f�"�NPZ*�|��Sӣ*�1ȇ٥�&���ҡ�5�"~<i�
x�@K����qG.u���=��!vBX����2�$�H�W�����g�h���|��1���c�߁��]ݝ��v�e������p��Q��q��1.��������T=R��&emK��~��
������]R�lU
;���y{A�g4��k`v�9�	M�h������?�}ܝ���lt�����0��MI>A���m�wR��Į���,'��9.��O,�.���_��vt0����0
f�Q7tض5Z�B�l� ����<�pH�B��nXh5ց�ab��?m�m��<LK�H�ѱڐIm�iXCF[Se�ۤF�M�܈�C�?�rN'5C>��ZL�kL�bhm\%/)�z5��V��0�K�B��"�qq�:a&$ifS
��>��X؄��-��j�0���55�6s��Z[Ք�d�M�CH�m�����X ��@�|�j����`LRx4�zI5�U7��|c��z؋Y�駉�ʒ������5�?A��dw�*���c��7 �Q�X�����`-��:1��)9�D�4"�-�2:B`�u]���6�'��|��zGQEv��S�!`� t��R���&�,� �Z4޾�Y�HB@�i z���P���� |�}"h�F���aK�[���L�UT87X�,����2�d��i��Z�dBu\�n���`��]H6�B���b.
i��%�6��o�n2�n��V1���6�T�+��}����	z�8Fl3nf��$�M��^�,���Qd�Z�4J��=tn� f0��c��V��k�eEٕڪCa�}��&j(�*V��tQ���5(;��T�&0�v�4�~��O� _�ؐ�Z����4.�~Fy�t��ۼ��-�^""�]5\���۩�xFX�% 5J'/_^"��#�M�r4!��3��¡-ɔb�p19�0f�ǃ��l?f�����b�7X�>n���}yGeL�o��?����\)}i~q53��@L3H�ӆ�<��Y�FSX��XR�U�ږ�s@Ri>�գ�����	U��V�*�r�X]��&�%c��=������ _,c���:G,gSG�b��-䟟]\�̞�;� T�u:/��n�[� ��a�%0�`�sС�fë�D9����(D,^���[�
��Q5�;ի�@G;˃�6D����F�0�z���:`�Ђ��?{ÄV�>B���_�7o�����<� x����X^I��#5\z�U����{ITR�ⴸM&Tt�A�fE��:�8ϊ���B�G��Lbc俌V��<ϸ��3��X����q����d9w� ���Q���1f������M��Ǻ���:D�@(dZ�����<�2�	�f��Թ5���!}��e����`���s0���
�	�o1&�������?���a����[��O�C�.����������Wᆎ���� hY�����;ކh�%���
<;���76 �l+ͶCv�Hޣ;��6�c����^C�.e�<#Ձ�,D#��Fw��9KL�n�"��U�F��t���b���j;��鮣}���kpy^�O�QV��:�y$���<��#޹/Y䛱�.� ������o�<���Q����>T��#�m����\��$�8ƹ�]炾�&N<��1FuŞ�ď�f�L?.j�D�c���|�3=��|[x�����?O,�.�^��=���х)`���ˢ�Ή�2s�������������Ǟ�>q؇N�7��_������oN������<�_��<������C^�"��$�bp�u�J�u�t2g$��%|�-�YɿD!��(�HM���ј�.vS5+�U;�wsh�,iM�v�����C���O��>6۵kp�}ܡ+d���,�ċ���O�@S3z{��TU��X��O��z�8��HER��ڴ�`�[�q�`M�5u���]u����2���5�f����Ӗ1A�ccq~���`b�?��Ց��7c���F�%5p�W,cIE�ղ{i^!���cn��Isb.)�+���QJ8�?1/$���:>�	 �1���qA�rj9�I�p�	�<��H��QQ�GB:]+a�ZH�U1U%��vs�&�b!����u�I�HG�"V[��(l�?�$ۅL&��m����zZL�dF
Φ�Q����G"j�"&l=У�S�bWg�ޮL�_S;�lu��@(��Qm���h�JCX�gY����f�R>n��*��T�������@�	B2X�5M��x� �P�{.�r���-��3�����7��!�b���[�D�,>,�.��<�����ѵ��]Ar�@ۼB/�i� �R@(D�����������a���*�W@���`<ŀo����p��uxe��͒ŮO�	�k�������д���w4�����i��6��M����C�E����|���7�� y��ţ��L��׸�����gR��4��r�	��Ž���+��Q#c�u�z �<����y���\�=´��6�N��c#�?���e.�����㘃� }���t�I�d�id�wfO�]�~���Tjc^�����m.������_�Gb`��s�~�?Y$�T��F�5��׿<jj�p�c�0���os(x��/�����
�b	~���ܖ�����z�C3�<0f%f�5���"@`_�z���n���@~�l�8?;��(��{,��ř<���?23���w�K)�
���^��p�[~^eط�ʗT.n���#2�����~�1��G�	��*�qo�\�n�U��^�!^���]�M`������?�o cf����hla������������?�,�>p���_i���	�?�A��?���\��7	��z��(UAa�E[yo3���:�wTɽ��F�PG�v��@4>��Pz�m������!�U��W�	V�P�ո�T�B)�Z�6��x�c�J=^[]��������\c��"T?�w4�[��"^�2������x:�!)f�y����F6%TEz�����q*%(����&�F���-�7;���"{z��o՛<�<����i��P,���q��+��C=U�O�J��jw�\��PQ�#�����aK{�ś�Uq/�,���Y.��m���A�P��㏥���ڹx�K�n�f�T���s^��GΜiۭ|�V���\��1X��2g�s��g�r�B/_=�PX���܆}�jq.�J6�Ia�*h��\9�ݚeŮ���;3Z��ZKk������m�]���k�e�U��ʛ2����+�M7u:�<HdX�v�D� �m�vc�{l���i�s�Nn�+v�7�-� {~̤��~��N%9]jb����6N��Ӛ�e�������^'fv9�Q��绯S���n,%Z�-}�uR��};���t�xgǌ*�T������V'.��\F���2S<ԅ�f$)��m�5r�ng�U���	F&��3Big�|2'tI����n)���Vw?}��|���R7kC�:�=������V<~��V�;��W$�*��
���I�`��n����PG��XL��B�,d5�t�ز6����+��RMd�2�����W����*��L�Ie�|�P�)��&鼊:��Ŝ��otlĥ�+ҩ��t2�L"�9�	���֠/..�[N-��@8��t��۪�����?����2�{7��2H`���{�g ��e�ux��O���m��~��뾀������������?�:q���E�>��I�#*��l
Q��O�w���b��7��﮸��0]	�˥R��l?߃դ�(;{��G�e4��+�ZەcEb�e����R��J�Y�)A(b�+{�$r���D�I%+�RD����G+�rVy��Vl�T)˙���s�ӱ�j*���]9�s�W遥�1Q�F3Z��n�>��?6:���po��v�U_��c�������\ 8��$������dnj�yD�23�cJ���	|���n�����~f�9���I��`�a�?���i>@��S�����/��/�����������
�y���c��
\T�5EṄ��\<ZO�16*�%���e�g����J|ee	P�m�K���|��������/����Ϳ������y������<�.]*,=�~"�������/}�������*ť���������ۆ���ҟ--Q_T�#�e�����_}2���g��3P�%�#�b/}��ǟ}�D����x�R�'K��E~��2�R⼀o��!x)D��V��������?����o������7t�����y�s��"9m>o��3������q6:���G��������2�LQ�w)	>=�㞑�� �Xi�����P�	��p��h�#Б#c3�嘄��+��W^@YRK��ऴO���3|P|�L���
	cf$�6)�^Xu�1�h	R�Y�M�r3<���򓐾��l>^�$��'V9(�Q���x]�a�UuV��Z�[�Z�V_�K��
���td��P�u�[#��]R�����
#5�g:F�t쉅䣤��D��#����$�q�:{�ɤ�3=�(����L�遅n"E5��p%Q��E���*REQ*J:�!�����࣓��	Āa�	�� 9�=r��CJ�*UI�tWw�<�W@u����������4����~����2x';���[�"�U*ڦ�?u��zq���2[�V�%�c+�D����^��O��ي��VV-#%�O�.�N�����*�*�h�xk�X޲���<���ȏ�*�ȱV���ۿM�c%XdU�#��J�$�s�	��\����?������t�a{�Ñ:�3�r�9Yg.s�j�?<��O�l�xo���a;�
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
]� ���+b�f�E7z�ʜ�#rHw$2y���kZ�y8�Ge�>��TpN�2��%GȆ���Y��Z����nD�<<��"* �/�*N(*�o��޺WoM]�9Q������H�r��>��s=ʋ@�M9�]n�h0*gkw�����Ը����?���Cc`�i���3px�S,������Fx{�O"0w������Gr��� ��'��`���X�Ŗ���G����������o����o������꿈��(g8>��(���"��.��<I��J���":f�$:��8���e�,����o��U�����F���a!�;�D�b�vH�ۜG�if~�C?�][���?�����F�g�.��	��޺���򰤫b����l�:s�x�I���ywն����E�
�k�͗{A��{���O�������S�� �-M������p�O#`��<俢����o\��G��4�b��?4B��1�Xє��h�7�A��	 ��!��ў�����_#4S�A�7������O����ߍЬ�?�����?���C�w#|��+�c�����U߿ؚ?�zk7�6e�����X�Շ�k��i�ۮ��Z�a�z:��k�|7�Z�֟�������]���~Ǽ�1�դ�I�e�^�S����r��%g���)�%�p׾Tû�([��0��e�Ga���f�>����Ѻ��y�u���N��k*�/�mߔ����ݕ�-�M�%Ժ]�v�lʞM�ֶ�#��;��e�Q�T>|H�,��T"�����̾�Oz�ݽ2i�*�>t�3+;F,��P�
^�D��3�D�X�����%co�$�7#�0������uϱd�PyA�t�}e_��p�*�P�!��������P�5 ��������A��F�?�8�C��?t�q�O�E���w��r���;��>9;�v��*iۖw�S^^w�@��mO�S�G�����&��bc(��X�Q��uÝ�ל��Ə��dkmzU�6tS�'9a���[��lד����.�˵����XY�c�n�:g}s�G;ɭD�M���n�jÍ������-\n�+��2���1֗�n��W�������%�ˎ<���{����!���p��������p�8�M�?� �����?���?���v����?�����S�����'�&�����#��4�b���o���߽�M=�~�c5�������b��_ �o�������G����_�����A4��?�����_#�������������������B�Y��@&����߷������?����A����}�X�����������������Y����[�������7f�E֙M��nm���@��������M����{�h�]�k������i�Y/kO���Ɖ}?e��6;�����ː��Ѡ�}>�������P9~26gw�]��ˀ�ꢲ�j��)��$+�B���������_U?8�/������Y6;�N|�<[�C�������1X��)KI��)\���7n���xZ~�����3�,�YT=�Ri|�{�/�i�隴Z�����šPm�?'\r����aq�������^�-}"�SΚv��,�F�<m�����E�G�8�����	���Zw��?"������g^���o\�?c�\�%2�D)f2�!iĥ� ���1Ee$+2�@�Ȳi,J4�r�$Q��P�������������������?�����������_��]��fE'������Z^�8rXpƶC�7�$���ک�)tŨ5�-֓��\��#˶�9VV��g��ަB�n����b�����	/tg�醜{Si	�z�z�W��9q҅��aM�6��:e��pOo
��8<�!�M=���F?�������Ё��C�2�?� ����C�2���A�?�����������P�!�� �1���w����C�20�0�� �����?�����!��?�� ���������@6�����18�����������F����?���Y|��mj?�B#_p���7v7��L�?��ᛉ��8?�!�/��nM^F7�4���,��h:��]?�&��٭.D�&>v©����m��Ƿ���R�K9�H�x�^�vXw�_�i55}vN���"ތʄ�M[�{���*3e�Se�R�Arn<6��:��SHKG����:���*����r7̉j�eM=����RF�8]�y]N���lY�Yw��-/�=��h�غ�����v(�{���*\�dfc������V�͙�FKS�ku~�ImrB<�"?��?t6}`Y��x�J�-�{��)���}�	tLY��:T��w)��U�w�|���#�����ד"�c�v�b�;��'�n��h�w��M%�SWI�k����<����8tO����t�T�}ݥg��j�\K�>.I��W�)��֤$��s\�y�.E�\9YR��~��gg�F
���b�,�?��@���?��}�8�?����H�Ny�J�,�c��r&�x)�"�b�$�Y�dҜ�%�&3��Y���<ɓ�J�L�������t������l�D�9u}� ���$6C�H#2Ldz���n��O�֘��oity��Y[U�~RF��V��.���K�i0�;��O�D*�Vr>��(K��:��m��f���}�u��%�|/o��O�-��'�?����k�?����6����?.��}\i��������&�A�!�M���o��/�C )������򿐁X�!�1�������{���?���o>���
!��є����/���_����\�{����&�+�(��@E2�����ߧ�0������o{xK�y$νӑf�C-ȵ���Z�lV3'/<�C"�g�ji{Y8S���U���S�6��t]v�} ݖ�MjnT��5k������<��io�� �jk��}�Cɭ����fpI��c��?��*u�ǉX�)���~?�7�Tew��X�LW�Rs��n����5Q#�Qd���޹�t�c��4R���L�Q����3�����m��_�@\�A�b��������/d`��`������������[�߾�-�k�0��t�M�2�;�,�$���=�_O����6������Rw�4PH�,���tܫIUB<�y����iV�{T:�!L��Ӌi�u�����Xך��!m�c�_5Ϸ��i"�Kѧ�;��V��k���~����`VPSٿ��%�^�j�H�s�WOVM^*t���F�]�-��n��e�z�2Ъ��0]���ڎO��<+��j�˔����ȮWjje/�KlM���V0���m��wi`Q�A�2���������B�!�����������Y�����&���>�S��>��3͗�1�R�:�C�7���/�����������:)���,>�U�ߝ�T�V����վt�	Kmv�|���l��9�=�<&\*s��T�9ūǽ�{������e�Zr5)��i]�N����'����������ǹ�/������Y6;�N<�K��Vfǐ��ȳ���e��n��L<S	k�.�b�m�LN�>�u�����#�s���N���݉��E�ͥ�E��2;�=����]Όr6=��2/iݟq���Y���to��}�:���[���Kv�RK�]�9U����.��� ���?��B���]������\�_���SFbH��*SA�r��#�d$2#3��bR���K4Q<�=r�H:������������_��+���p�Du�a�Y�`pu|o\J�y���nlN��ր���e�wwjMf
#�����{=�5����t"� ���:ݥ�չ��q0��l'ɗ@��B�^����]�����d$���f�$�}/8<�)�~���w#���'�;|i�����#y�M����S0����?��bKS�������	`��a��a��7��X�M9��3)ΥLHEI��4礔���hNs�MHNL��JH���c2M�Ϡ��f���_��)��i�_���f�M�\��J����F̨�Џ��d[�<���[d{s��}>���5�N�~;l�Vk��c��=�抖@��N2�E��Ӎ�5��s�4C����Xf]M����luuVT��z��ޅ������b��?$�5�����*a [���?��g���F�B�y�EE3�1߸���Z�i����h���b���)����o��m����o����o������B�����+���w�������hV��������7ˁ�o����o����o���0���f�?��������A���t4�������[���������?���������7E�>��4q���s��������4�����᱀����O1��/��7b�������G������o|�VQД������ ����������CP���`Ā�������*0�0�� �����?�����a���?�������B���?d`��������o��!��!���q������Uv���C����w����3ԋ�������s�$2i��Y�qt$�R,f�\�Id�dL�2	�$�@&� qq�p$�	�������z����78�?�S��/��o�/����{w��/C?��'�5�k+͊N�ѣ7`Ys)�ګ��w-mj�[vίH?gh�����D墀�0釻���o�JN*ѓ��$���]�<I$�R��Z��{mۗw�vt��14>��h�	�d9qT��t�!�����,�`����ΜM�~�VF��N�8c����R��{��X�����pF3��P�Ub:���2�1>��c�0�YP�䫍�{R]��=C�� ��;�u�_^EA�G�Ї�?�ݡ��?:C���?:�����?����������������?`�������:� ��c ����_/��t���?0����������?�� ��������l������7���p����O���S��m����˷��<]�rY��t	�v4��?~)��
0�.������7�5G�b_i���7$I�cx�2�B� wh%إ�G�Й/���x��og�Q,.hw�k�Ƭ~�b��m��y���>Y�u.����l_����pm[�hMb1P�ե�����\
�)�AF��f�/��|�R-�,�)��2�4ϝܐ-�����X�w���t��������l����ݡ/�DC��>x(N�(���áG�1#�����aa�C�C���
cr��1
�?~}����~g��(x�ny�-��=��ꖧ,>��V����]e��~��0��g��3�&�6��x��G��8f��C�%3q�j�l�.7h24
ک�i>:e�'���zL���w�y<;� ���7?��!��S������?��Q�����x��������o��<�W�#������0����������</��!���8�q��D��^8���b�O]M��D$3$�0����vm�����h����N����e��zv�%8���efc�G�)q)©U:v���h�%����Srf����,g��/,-�%4#T'��@���ds0�<(��T���������pKΛ���U�KM����������oKh��A;W������_���'�������4���U~���p��d�ܔGG�L1ub������������_�x�f)Co�䥱Jl��|A?��%9��-_Я�|�n��^}k��o�s��R�&_Z֔�'�����$��Y7�v٩׼-�n�	�U`y�^���u��:�2�Ū<�9��?7�m8n҈�#�~ϲ���q8N_������k��1�c�{k
�����/�'��P%��'���๦SK?�L�G�?%kS%�����������`
�$g:s1�&*E8�����t6��\������2)nCaɆ� �
O;rP�Ƴ]�5��tt&��+2Y��%$�G��������/������@/�?�@����V���������w��`��;���/k���Po������;��	0��
�:����٫�+X�G��I�ᑐ�j�����S�F����h$��������w��@�����R���R�Q��ў�
�5�@��r�euQ�X�2�`�S�p�D�����tk�D4w�)b����e˜�K���
�]����KQx��|㣾��a3�Uo���/2i�\�ev2+k���Щ����r��k+R~���3Yf3{�kds�v��a��|Є�*��D�3�-"<�]c�#[7�T�t-!4Ϩ<_�<�l�RsF$e�w�I �K���bcFL$V��s�/p������o��������?��/��������wh���C�~�So*���E�?B>����m����7�o�/���>8Hx�e^���j��M�?���L۽:�F]䍖��s��"���2�j�?7ܼ2�n ׶΋[֏���[y�^:6��B�X�ɘE��Мm���n�)|���f?�u_Z#<��]�$j7�hm��E����A��gV�}i���m3QY��{yVg_"}d�q�8闣n��;���A�PK���H�U��b�����/����~�j���!^��(��?�+V@�è:��U�riD�)i�1iE���B{S�Ax�Oqy
bc�q��k���fl�,�	����GC/�B��ߎЩ�گs�A�=��@8�m���)|��a���&�5��Wa���A���߳���0߳���w�a%%q=@�C*����Z(a2����H�d;6��wV+i���m�Z�k�=cD�n�\3�b(a6�L��U,�&/�=�lc��*�z��`�J	-Z�>]fL�ʴ�dR��4&T�����7�i��8���PI�Z9[��q�y��H�˔3�
>���MF�'|��R!�KW>����_�N�8��c�(9�c���P��������������/���;��������6�(��}�������ު�٭�����;�^��7�rU,���n�[�'k���VnH`뫲26��g����t�Ɔk���-�/��@�}�h.�>�6<�O��ږ��o\������ʥ[4˜���dţ�	�Dud�.Θ?W�-/?>��Idf�1<n�u�uqW�|�k�����u`�߮�4�����U�����i��9Qr�Z!tq���of���
N�j���y�IR>����$3G�Y.����x�������VЕ�گ��{��D ����'���>n�S/�������!`���������i��=��)f�O�Q2r�*��\@�3�iy �uIP+nx|E��n,Zܑ���;��%2��n��9[�׈�(I^��sm}����X}�Z�j#K�h�cHVU��-��m�w�~�]�͵�r�c| X�Z�p�����)��;�+�ˊa`�(��!*[u͢���K�Z��x���)�䙔��r��Vc�3��h�S�y6����o��wU{`�KGh��_�	��)@����}�������?� �}�����@��@��:������@���?}�?V�/����Wh���y�O ����^�?}��I!��6��߭} w�� �?����C���_����N�~ �?�������	�-�����-����ߕ�A����������������`'\? �������A���������n����������0��_������l���������� -����1����[�|������'+X�G��I�ᑐ�j����?��������E#��3͸�J��Ϲw�s���50ȲJ9O7OHuFe�G{n*D֜�ŏ�I��EuTcM˄�eWL5�¹��rN�ӭ��܅��}^�J×Y,s2.y��iT�����KQ��,�^㤾^��f,��՗x�\�ev2+k���Щ����r��k+R~���3Yf3{�kds�v��5��:?�b�Oyi@����MF0�-]K���3*�W.O����\�I��zH���e4��ؘI�U�`���A��#������<�󿭠+��G�.��������������`�s+�����&���b'(�q���T�:$)��(h:��H`��AD�J=<���O��~��q
����6���ύ�uu?�d������Պr?J��$��ng���)L���/�v�0��z�"�̩�B�MS�so���`o�k3���$�s�
�6������͢9� étBО�d���i(t[�2�-��f�
/u7���J�9U9I��9Ѿں�'���3�����w���[����2oO����+�Ł�k��������
Z��Ͽ��@�
���w���`��ZA��B�:�����?q���?[B_�t�v����g�?QP�i�����O���m���_P�k��?�9��������?��@ ���^�?������A����@���O ������� ��t��@T� ��c�^�?q���?������G�I@���r>��������V������R&�jx�����	L�ٿ��%���7���[;iO���[�l�{
��j�����g����A`�@�V���	'M�ds�9%�p8S���l"#��+xa�aD���s4gsmն4JWr�7�^�k~��8�}�61�t)�T��FH�-��f�9V��Nn]	Э�?�u��D_I��q��!�y���/M�zu����8^o�v���C���?��;���>�V#\��顊�j[R�1�	-�:ﵺzbSV���Lp��a4`!yGL��9&��`W����\����?B/�B��ώЩ�!P���������8� �����~��xDz^�Q��C��*F�1IE>I2>�h|�!CQ
� �)&���d<����?��>����O�0�˳)�����#d;�|����S����<Kms��s��"8��x3-3Je�.���$.\n���9��	)�̖c?���LN��3Lߤv�˯1qj�G�N���U|<�O��{?��OI=z~�j�s����&�;��0������;���5��xJ�O��S���St8����?������|�2��ۅ�_P՟�'����-Ƒ쪝��lϝ�ݡ��LLk��l3cW�U.�^~�ˏz���\/Wٮ*�l���J�QBP�%�)���I@��m$�"��@�/>"�JA���v�_3=�ه�VwW�{�[�sϽ�{k���vl��c�x8�CL��j��g�.�ww^�S�X�/�p��^�LB��P�x��D�7^ى}l'v�F���*�,��V���J� ��jW��K��6�#��ܙ�{1��wZv��nk�{JH���3O�t�ԇ��H�Fnl!!!��JX�k,��ǂ��ĆcǱ3�SFa�}:�r����ӧ�;Ų��{�H��=��1I���=e=�����׀�v��/���
�{����a���QG���%l���]ۡ*<s��0��R�"J�P-�wC�W;G0�$�R�rUB�ߍ�#5�9�N��{�N u�Z�g�;1Oׇ�;G������6�vc'L"?�N���m5֟��={�%���h_��MCz]�9�a������Pv�2������m�d�N�лs��['ǻ5�,�ة��DF��	q��p-'�����	�7.��A}���ŭ������C;�V,��K0���fh(�ꩄ���HR�ۚ�"iK��4�p
N����QCM�����ICqǡx2r�B׿�}�7?�����׿����l���_���7�W�7΃�=
U���˄��,u�������P��P��'�n���v�*�p��ָ�,���B8R��r��s���n�;Tϡ'�l��)����3[ ��|��T}h�c�=]	3/��<^W�Cy{	/��p�C���l��?�����/��ӟ|���o�ϭ��w�k��W�K��\�����;��Q��c���ݷ���y���)8qD�S��������إ������S���{�S�?���~�?�Ɲ��ٽ7;�g���(�{��ޔ�|b���s�X���Fc���B��K{�%K�51T����L�`CIJJ�ө$���6�D),�����hO�)I��%����K��귕��ܟ|�w�_��?�.�������Q��A�>y\>z��'Hѿހ�q�@ƿrm��σ��o=�����d~�����B�c~��zB
	z�(�kZ�v��1?�J?n?xN$�~p&������H����' ��Z�D5(Ӆ'Ζ�z�f/҂U�M�����瘠(KsF�BzE�E�[C��RoM�>�5E�Α��+O���dǠ��f�:j+��ݞ3-�T��;\-|w�У��+b����H�o�_�/Yh2Ah�y�/�%ͬ�<:˛����2��\51c�~����Ipߞ�Gx]����P)�U�`9�b=�؊H:'l�'=�h-���al�F�|tM�#���I��#�;Gu��5��(���2e�4 �n�hM�\3���X��ލ�|�{�Co@�/��C�R�j"m0@��AE����TV���"�gJɂ/�]tq�*P<�h���!�uJo��f`��p���<��҄�kp�C�=��"ۑT��R��0s�<&A̜�9_2BԜ�S��&V<���v�����i6!r�޶��$��V]��W�g�"�h�j�R+�[��C��A$J��P�GT��R���%M{�����l���n`r~|�Kf;��#�{Y �([���M ���hFLA����-*$�d���|\�a�U�ל8	��('(����q����_hr�BE>��w�88n�$8F�
�8��Β�L�A�p|���ɖG���h�r�t����ш��'�<^��ݩ��OT��I�k�Kuʭ��B�@lK���H�w�Y���,gr���+MfY3�j���:d]0���rW��5yn²P�F��:yF&�Լ���T�eoT�N�%�%��P4˱R˛��f�Y�Z���F��qL�j ��8�&�ӫc�#ȇpOe��0E�Xc��y��'z�sꊛ�|�'ƹ�+��R����Yfs�!������E�������~�%u��`�rg�E�b�����Y;ڷ���׵�\���)V�Am�FMt�GF�P�Ez�8�.�s��Qt8��(1l�����6�������gش�ϰ	i�NO�cG�����qYhg�dy��z9#B��OR^��يN��
���I֑��q���0i�p�oK��lU�9E(�����SǱ���l����\����` �֫����'���Ê5��U�B����Q	����D�l3�e��d��K8��Hkb:��zY8-t�nZ��:h{�U�QH|��%�br����<3��_�UW=iMr�D:>y���π'�<�@��(����I,e	��pE|ڂ.���o=�}9Z��M�W%����&��!�G�
\Y[PG+���쯉�����2�o��ɿ���ׯ,'�]��t��+�����#��J2�/�]&�Y�$VdS��z/&Lޏ!}�&��Y&�ǐΠIi�)6��쌽k	Ҍ��t�Ւ�t������˞ ��*��*HG4��ԆsOǹbJ�U��d�b��3F��Ox/&�dN��*��Սfs���zp�زa����mN������L���=Nޙh�j��e�@s��|���͑�����j0��;;R^���,��M�]�Q�4��hY��d��}�һ)�p�vE4���Ǭb	��O�}^�r���b�*�};.U�1���=5T��*6^�����<!)��4&�lMj���XnN�0�Aט�����iI�O�ܼB�H�e�A#3�4>�H�=p*��n�X���n?�8HQ��{?�73R��i9�5�j#6��:]Œ�.�FU�kj)ׯ�JЯ�t�4F����3����&T�� ���^�MyW�DW�*d^(2	F�)��*7�6Y����b�GU��;P��	*v;���V��[�r��۳��<���hk�-G�t�_�F�/|rП�B?���m�������o.��7���	}���o<t�ٜ>�9}bs�ĉ���?�^�F���h/��k<�P��F�"��#���r hb���tv#.Le:	}�+Q�]:ގ#�r�g��x��
YQ���[l��Z��u���@���Ne#;� ��rc.'q���&��tǓ�2*�Έ����S���M��O���4ݳ�Ԩ~ä^�M=��[m��l��l�,[��,u�r����U5�pVWI�����f�/6�C�U��3(��^���v�f	:�6�4?���T��96~�����ϱ�V��C��Z�f��x7�ó{���!x�Ջ�W/~:�zq�)3y`e�}t���fe|zzݲ�^h��y�B��z�2+��/��Y4y�-u�#��G��Ep%���3O��B����s�Bt/��H��\���.o�����~�~l���8�������)�!M�W�ҝ��];���O�kG���p��q�h4�
�E�,��J�Җ!Χշ"�p5���1���H�>E6���}|dQ7�����h8V��!��~³+t\��Bӆ���>�����w���_a<����6��l`��6��l�'�u-� � 