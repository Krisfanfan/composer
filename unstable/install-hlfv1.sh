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
� _PZY �=Mo�Hv==��7�� 	�T�n���[I�����hYm�[��n�z(�$ѦH��$�/rrH�=$���\����X�c.�a��S��`��H�ԇ-�v˽�z@���WU�>ޫW�^U��r�b6-Ӂ!K��u�lj����0!��F�������6�rB,�2���l�`��k�帲�זۚs5ޤ��ShC��Lc,s��@��)�Y�( �1a��o��pè��!7�Z?�DjM���]�:T�Ў��C��Z��:^� ���
�¬���I4ښmMh�=�d>[ȗ��Q2��Ȥ��w~ ��_ �*��-�M��U�`�5M���zM�ښB��P�Q��RǠ8�W����(�f�"0��e����03��E�~�mv4�vwe��6��4�&�x$ܨ)!�r�h�Z�-��2�H�i��F�E��#M@R�lSQ�-e-�Ӈ�ܴtFd����G�^���EiȨ�H��n��Vӱ2)����l�\�P�1�wIy�u-D�"�*����ջ!3��O[�qwJہ��y0a�s���QBr�m�I�������b/Yˆ**Y��y���զF�%��씥�h��=�au�ɢ.��vL���_ZxB���6d�'rEܑ�Kݷ�~�uDH���h�F�<����U�?��6����s 甌��|���.�m���v�-��?u�������l�#�_<����<��W��fD��Ӡ�e+�O�E%T�Ƣ}�K��ͣr~����0o/h��_����"G�)�i������Ǽ���^����,���1�o��	Z·�Ӹ�2��'v���ey���s\)~����������d�E�F"��p��m@݂6(�0�&�-�q6&, �P���L���P7-l�A����e㵗O�ekm��4�v� ��6L{Ȩ�a���HD��C�q�h��^.��n*'JCF�Io�I�M�����%�[��4�jV��^c)rH�5D7.U'̄d�j��ނ��x=6� q����'L�%dMM{�(���t5$�JCk��zK�@(��`;{�5�#_�:5�:��^R�CC�s͋bñ��ʋB=�Ǭ����peI���bn��������)�;p[p��ǡE���G!�b�7��c��<Pk�(܆�M׉��a�lC��2ͨ_n
8T?����g�;�*��O��d���g�Vo�6Y`���:�i��%��@*�[�<����-��k�;A6b�t[��$g���¹���`�ܕ��p%{�OS��$C��r/p+n����%q��DY�[�C!mV�$��Ɯ��`�M&�K{��:@�����q�=���}����ی���8I�f�g��+B`kh���%�hc��>������ު�����EQvŖ�D�v�D�]���á
��:]С�@�@*.�44�L�݀� My���S2@�׀46��V� �9���Q~F]h�6?�7?E����oW�������<#,���哗//�J�#zM�r4!��3��á#+�jp19�0f�ǃ��l?f��||���,�?7���˾��2&�?�7{���]������4�x��gr �����jV�lS�)���m��)h-��9 ��4��R�Li�Klf�G�d)S���d��1���VW�W�O��/�1IDQ�#wCL�2ɣ]�T��s��..Uf_�@ �Z��HIwZM\�灃�ϰ�L��;�PPw��y��R`��`"�TF�-W�R娒�J����T������S��R�g#UH���^�Nh��埽aB�o�?!^Y�����7��؂����}���X^I��!5\F�Y�6���{ITR�ⴸM&Tt�A�fE��:�8ߊ���B�G��Lbc係V.��|ϸ��3�_����q����l�w� ���Q����1f������M��ǆ���:D�A(dٰ����<�2�����sk��C���˘��3����s0���
�	�����A�������0}���-xR���!��c��\`h�W«p�@kp�q�m�~,[3\C�ٔ�	Sx����?��P��F�%�z$��Il��1N�qa`�!D�:p��j�S"��t��c�ʜ%&S��T�^њ������b������季�d������B��&�5��H����Z��ʉ��R�d�oƦ�<��F�z���[�D�gF����?�P�>|��/�|OW�8V����l���zrX8u�ث�<�;{�"	�f�L/.j�D�cz��|�3=��|[x�����?'��?x�����\����0L��%ILe�pS���	�����Y���?x����'��mY�f>����A����m�I����G�����7��+WD�7�ܿ�\fݣ�j� ���I���~���nV�/Qȡ9�?R�ĥw4�	�˃�Ь��������z�t���#��k���u�e���5����2O�m������Q����=Ys+�wb,��O�hF�<��HER��ڴ�`�[��7���~G��w�2�Wd(�#�׸k���3�nO[����	���'����$���o���叆K<j��Xƒ���e��0�B\	��ꅓf�lB*�K�ɣ�x$�RNLlK�u|� �m1ד�%�8�r��r �%�2��.%ry�!�̗���$���T�$���N%��*R�B���fQMR�|&WYo���lG���Q�A�I���t&�>ږv������I��I��	.le�$�xL�z�Gq��Ů̆�]��,%wJ���@'^�P�oo��`���P����ϒTY�v��f�tܲ���k�I���Z :R���Ch�%�C�
�sɸ�ۦ�j�~>�hm\�}3��,����M��Ǆa���p!�����荞ŏ�
�;Z�z�L�(��
B!r��� ��^�v�n5S�VY���
6�S����� b��L�Y����|�w�z<�����������
�����\`���ͥp��?��P�G�`!�����M�?HA�{h����Ia�]�k�@�Ӊ\Ƴ���S��oy�y��^���@�Q��:p= B����<V�{.�aZ��K'����/,��|����8�`+@Ͻƻ��
]yR*E�A�ٓ�קߠ<��4�ꘄ������K!&������X����_�OV�-UM��pA�O���]5�N8��1xM���9<i�������
�bq~���ܖ�����zxC3�<0f��V�3���"@`_�z����n���@~�b�8?'��(��{,x�ř|���df��/７R�>����?��?�2��ʰoÕ/�\�LzGd�)c]#�IƼ�2�x/$X���%ƽ�sݻ5W�Vx��xU�~w�6�ʃnS���p�������ƣ���w0s�{�n�2f��(��������J�4eL����2��1�[�s�w�$xw���4��g(�6��xx��-�м�����4���ױ�L�����k�hG���X��^n���u�*�YB�Z�br-
ea���+lTP!�1Q�&TWW9rB-��rњRS����UT����M(��~/hڮV�rw<�ҙHJ�Jf#�+	=4��Lr�8��t]�db=S�����������[��4�ŭD�~�89��Ŕx��d�N��H�S��bZ���9�*YT���H�Dv��m8��A[i��~E��&�$.q���p��t�=4���c�u�z.d����-V���l��az�U�g�v3׮V.q�3�p�7:�Y�\d�Ǚ����Ud����~Xv�9C�8_%�݄�_��J���H^�2R�J��Y��n��7���ΆH�6�[�ߋ����Qm�,�˵���Φ�:�J$ҬU=I�vPζ����=�SM���U7�qґ:���Ɩy�9?f�bq?��Ģ�*�E)�ʕ�'��iU�ӵN�uysk��:��������Ccs7���Ė��:�u�������ƞ���Xу|�<���;�n�9�e�b'UG���¡!7#	�o}��Mdq;����lV4�ɤ��;��Y�C⤎��t�ɬ(v�:��C�s�H;S�����9��,,z��5W]9oo�^�M;���\���'��4;ɺW�C�[Bc1Uꈝ���W��-s��h�ӌ�j��j%��J�l�|R[I�k��rZ�&�I�Cc�T,XL��*���s�zv��v��ȧF�}�N�3�H�� l �RcX�����o9����H8��mӨok���k��D��˰��0}]�A� #< �����i���M��=�����C�E��������&*�����?�:q���E�>ؒ�I�#*�Io�uI��O�{�.gc��7���H3���b��l?߃��k�;{��G�mַ[+����cUf�����kr��J�QsIQ,�c�+g�(q���DR	5�XrD3R��G+�JF}]ϔ�T-)����s�ݶ�J�2��JeC=ᷳ�W�Ŗ�Q}�f�b���|�lt����<����V�������ύ�����@p��Ilg����7�����df6��׃�0e��j?������a�l�2&���������� ��O�w��g���g������?�?���7?eW�«5��c�U�2��*��e!�pB�gclT��J��)LU`�U~EXYY�`��_�C�7��-�y�/�����_�b�/?}����f],��!�7��B��KϨ����c��fK_.���qޮs�ra���%?��)*i�i�Z���gKK�e�Hp��?}��W�fy��'��@I���8K_,��g�.Q��_<Dq?޳5��ҟ,=B���p\	��q~�7~�����V��������?����o������7t�����y�s��"�->o��3��������棋�_����k`�[�(ǿ���t���H_}��4yf����MR<�^4��*�����rL²TڕJ�+'�,�%��KpR�O���3|P|�L���
	cf$�6)�^X5�1�h	R�Y�-��2<���򓑾��l^�r�\����(��5A�)
��j���2W����Z�Uk����@��#�������ꀐ��~0p�U��]�5{�cO,$eC;'��ٻ�����'���x�`W�3I�f���@#�M�DQQ�rh��H-E�(�4�8H.F#��N�b'H�}3$@;� � �!�O)��T%��]ݥ�^�����������p���F|x�o��U��d��9yK^D�JE���na�B\/β�Pf��J��ql���rҰa٫���s1[QV�ʪeģ����υ�ɿrQX�Pe-��`��[�r��Sp��T�9��
��#�w�wb�w��r��̣�r���\ɝ�yn<A?��Q^\ �G]w�<6�����?��?l�;`82@�w&�B�6'��eNV����V�I��m½�MQ=�3lgW��g��8Ν��[���^{�D��o裍��ﻺ*��7F.�1r�#�������v�+���>����$�vp�h�rɳn�{I�9!��t�,V�*sqg���=�tf���S�Z���������-�#�s��ڮ����'I?��^Ϗ�r�5^t�[h�p��u����0���ĳ?���5N�#yuv´�5�$�8��)�����,t��HW�Ǐ nL5S���������ViT%^���ѱ��x������++��.3�BR��>��j,�������C�n����(sa9"sC�<���$�ى?�p��3��n/�f�X���^|�l�tԞ,��g��N �f7��rn�����կ�/�5�f�86�O�r���g����6���U�����[�8��S�ۂ���.�����ON������t?����V���{\��#X>�����>�w+�wx�Տ�����+�{�_�����;�����_>�A��=��&���:�:��:0~��7_:|�����
_K�mJ�5��1���mXf:jb�,n�v;k�3m+�AaS�uE��504��z����A6q=u�z�.�������o����w~��������~�{�H�P�YI������k���0���S����(ڿ����;�1��x��w�>���[o�~�V���:=��W.���`��i�S�%�6��r�zθ�f�]�8I�\�nFÖ��.�};�����2��Q�n��s����&�;�{d}y�P5>�R`����5��r
�\2�
��f�9;i5;�I�-�tZ�<����1*�bD�8�b$xu��|�->�N>�HR�o��$�7�o�3Q�˒SH�HReC3��\._���R6�7d�9��<)�gB�ՠ���Ó3$c�}/�����㐐4#�Z	k��2��R�j ��E�/�L�M�zd+��\gY�)GJ�&�qF���)�H�ڂI(�&XJ!�$�X���:�KѴ[np{�T� �t�nͫ�iO7�y����^ q��KLw*E���˒#����֭���)DT���()WF��"1^�'X�H���e>h�#R�@U��îٱ�g�>e
�P�#�O7�6�M�ӗ�XU���*�_��(>�v6V;g%�$��EE�S{Fw!��^"�ݨ��B���g�1�*��D@��ΔD��kH_����[�ܡ�!$�MB�jN���1��[�W��iX���0��ZW�3���#�इ�;2�W��Vzy iO���@דȋ�%BA�"�L���*Eil>/�'�K�(@
�0cNn��Uj1Hf15�j����.��H�c�4	9����"9��`~�Ns�&���(N�֐����l��|��s�6�X"Y�P��aN�S+3?2l�_�<A�����d�D<�1l<ک���HX�9%DN׏fy'���x`�x�ϲH�k����X�#mfEcP`UjB��6<�����ڠ��F��@ms�s|�5��@_�LXH�'�a��sۨ� /.��<��6������0ʐޜ�>���U�����B��+��:$����nֱ�0D�T	�F|�s�p�/�ԨaW�X�L{H��e��ާW�뛔� 7��nZ�ܴ��ip�*�E<�Mkx���� 7��nZ�\�~��B��,H$�J��W[��A�[ٿ��Ń�R�R�������_K6�W���������/Ō_\;��چz�!���xO�z79�)O���{�?z��[������R_����{��6ޥ�9㽊���ұ��r#��K|ډ�^����t׌w�:���54)�kJ�� ��yiW��8�ꭖ�3�Zv�X4*C�5)�HG�������L�R�.�4g��J�W3Vm��P����^���ek=������R˃��6��S;��9}�x/��;K����"K��5<t����]��-Dn���H���pP�8E��H��4��7X3/�uu�2��Z�0��������U,�9�i�/Y5�NfD��qK�NT��T�LwT�ΞJł�Qwڄ�N�H�)�M���//�[���ڑP�������0&���Ƒ�ͫ��D�|=h��)Al���j/�?O+ua�I��� )�!
��)�Z��=F���hf��ld.V�Td��q�jf���b;�
���x8D��vL��T�.���iUzSɯ��/U� �X�U>C�2���S%�)<7�<��E�B�"[T�!�E/���u��j~�5f��S�|>up�,�O<���N.�طH�y:�� �4o �?~��Rk�A�o������o_	1���3�S�]���8j�4���e�r&�P�-�Y+�<C�Ǌ�FέGI�Xg�v�h|�*��
�M�QxXYG`����G[��/��b����PH%�z�
���)�%�[��������pB ]�k�b�A܀��XD��3���&�E#����)��L�6�tOEG���j���ѹ�u���#ݨ5'��8 �X����lk�tq{����&�d<��FQb��K�]��� �����Μ.���a������mi�����	t�"¶<A��ӑL����9/a��$;d+;���B�Lw!
A�h���"k=��: 	r�W�!.��N��A� ��
�A�D�"7ъnE/� s;��G��K�ue��H���^/�{k2E�x=t[�RH�&O`k���!Ǳ�zF�I�l�|?X��ݧ�u��f@D��ҙ���@O�<���ti.���o�|��z��%c�����X!�6�*J�O7��vwr S��c="�`!":�5�e#n�b��N6�&"�o:�,)��P�kM�WzZ+�z��N����歚=���jfź+�JX�F#�o�U��a?��*�yÓ�k�
�~�c���~�c�ϱ��xa�9�Ѫ�C�>Z��V�w�����=�ڕ\H�Ũ�A�jtZ�V����L#��	�?�q����;�G�3����k#*pj�HX�T[��P8�y0��T����e���7�É`W*3R�\�ӀY+[�^ÂR�1`�n,A��2$��u��Q�D��1\.�1�2���:�
�HJzd,���Z�
4O��k�`:��y�ګUp�.s�ѸOhźWm��
��Au�C4�!�E���o�.ͥ�c����r� ��[*�F���������.����á6�Q+F�l`� Ֆ��"ǂ:�Cj$Ҿyy\��P&ze� ����R�kQ�7R��G��O:�^�$�$z�sN"����*�)Y�x�.�����c��_�%9�� ���lh��L���=��D�U�=6:�;�Ro�^; ������~����˼��Q�M�S?��9�g��J�{�t��9W��s<>&^�9�w�W#��|�����k.K�/���P����;pȞ��L�~*��|�N����f����y<����x�~�N�	������9���
S��:��V͗i=���������ϋJO��e�l�Z�x��������p�7�f��������m�3������������݉��������z��Y���﹧�t����#��o���#t��,���۠���j�w��_x����w��0����=�������x{a7���=���1d3�����6����bG�����z�>�t[�I�g8�������?�
��(܍"�}���Ga�+��Н���-������ڱ�g����Ni�����ߝ���>�cWtG�������!�����о���Q�� >c� v������o��`Y|o�����K^]�� �����m��	��V����6����v�}�9�]��3����{��6�*�����ʟ���r0,U�#�4�7�-���3�������
:����B9���.��i�m��<	�rr7��P�u�\���C�
<�yC�"ʴ��71�����Lj��<�$�*\�q#������g�� �ڣ<Iw�L{�8������P���>(d�0���u�G�tc�zA)��u�Hl�����p�e���q��t��&�E�&V�q]o<vĢ4���h#��5�I�V_굠99q��j�t��P�t�xYw�]��gOw���7�?,����۠�]k����w�wD{��Ŷ����pf����
�[���	��aE1�����-K�s��B�n�팁��v�鸞��t,��f6������6��Gqx��G���mК�_��j����Y����
��I]��LqP�Nb��Ǎ^m.E~wP�� #�qE�Ѭ���FoV�tD�D&/{�Ak6���և��
�)�Cf3��h ���Y��Z����nD�<<��"* �/�*N(*�o��޺WoM]�9Q������H�r��>����ף�4ݔ��n��6��r�v��x@�Y��N��}^���P��;4Ɵ��M���1��?������n����$s�/M����$��	��Ax�
����U]liJ�t��������o����o����?��ެ��h:�r��c:�bN��,☌�r�ϓ$˩Tȩ(�c��G��8�s��XV�"�����f���_��)��i�_��r̰c�^�H4)��a���͹p$�f�W�=��޵o]�S��aOikq{v���r�^�P�쭋��� K�*�J!����˦�37���4ۉ��wWm�x�{�ZĪл�|��W��������!a���^�7U	 �������?��4��C�+*���������O�/�@�C#4���M�������� �!��!����/��P�5B3��|�
���]�������0�������?�+��(������?�7�7��?��O�_�����Ӭ�v�lS?:����Z}���������ڜ��Q������V�ws��j��ˋ����u����w�;�\Mڝ$Z��e9�iY!.���Xr���ؑ�YRw�K5�{���X
�z]f~��znV�Ӛ�.�;]њ7Zw	��^��������M9|�/�]������XQB�۵n'˦�٤mm�
1R���[6�M�Ç���
M%��~�_����+�����+s���R�C�:1��c��2���0��M$.+�1M��U�IzZ]2�vNr{3R
3���_�K��DK��W��K���q��bp��^���_�_��?����`�����k������8���C����_����zg@;-�|�λ�p��#nW����my�9��u�	+��4O9unqDm/��ib0�.6����[^7�Yy͉Ml�X�O�֦WkC75��i�����v=y�����\����ށ�U>�06�v�s�7�~���J��I����6ܘ�������������(J9c})P�ƚy���i�?Z\����s���7p��(�P�L����
��������_�Ѵ��
^���a����?���?h��������o��?U�o��}�i��������7�O�/�?��&hJ�����S�<P���\�)�Y���&@�������Ͼ�������XDAS������5������������A��������?,����T`��`���}�?���������/����11���w�������������� � o����'��!���������c�[d��Dk����h?P���������T��Ai���Iѕ�f�z��k�F����$�=n���S�xn�3�_������^��C�XOMmM���'csvw�UK�h�.*�F˙�L�",��g�O|�񻻻����U�����ڛ_Z{��e�S�ħ̳��1��?n����թ����i�j�{�;��g��Z���9�R�E�s(Ց��g�R���?��I�e
�,L�\
uж�s�%�i?9h��i�u��'2;�iǘ�o����z_hX�ԋ�9��� q��ʮ�qw���#�����p��U�7��F�E�36ʅ\"�H�b&�r�F\J��qISTF�"#	4O�,�ƢD�,�J%
������������?�?��	�����ݝο-������u*_[iVt���˚���ˁ#�gl;�yH�?X�����BW�Z��b=˅-�:�l{�Ca�a����p��P�m*��n��1!/����,��Bwƛnȹ7e�����j��~u��']�}A��ncͮS�O���P������?����_~l�������X�?� ��C�b@�A���?� ����0����`�����?������?��}�X�?� �����[��������?��CP�A�b��������d`���/�>����g9�Y�9��M�-�o������������v0��3.4�G.ns`w������c���������"9���et�I��_�B���������k�����Btn��cG!��koj�f�}|[}�.�п���t�7�i�uW��VS��g焽,�ͨL��ٴź����2Sf:U�+��$���cC��c�=��t4��Z���ґ�?:,wÜ��\���ȉ�+e��ӵ��u���̖5�uǙ����؎vP��(�:io�ϻ�`�o��uKf6vn�N���h5ܜ�h�4u�V����&'�Þ+��Y��G��a��e~��t�r��;��r��k�Ǟ@ǔ�ڨC���B�Xu'�wK�<����~=):o�^ F��xyr����V�x����T">u�T��k[��cmo�C�Z:�M���N���]JpV���˵���$;}���mMJ�}0�uj�7�Rtϕ�%����yv�o��>�.��������d �� �1���w����C�:p�����$��8��(g���b.)�O��I&��X�h2���)�ɓ<����$���9p���@ǯ��p�a�ϦJĞS�gⰛO�`3t�4"�D���8��x���a�YjP��F�Gڝ�U%�'e�^n��;ἤ��Si��N��rk%�󡜎�4ʮ#�٦+nh�����Z��]B��������"~��cH�&����^����g#�����X�Ǖ&����Z �o���є�?�&���8����\�!�������\��������������0 �M�����2��5�����żw�l�lb����Ҁ]T$����}�����O�����ĝG��;iv>Ԃ\�߿���f5s�³9$�}������3E�i[u�<�o�M�e���m�ڤ�F�~;^��[���+�S[��vKҊ��v��W?�ܺ[��n�$�?������Rg{��e���j���zcMUv��e�t�+59�F)�N_5�eA6Z_읛Nw�9Vz�@#5oo�ʄ�X8����������
���!���������B&��8��W�_��	���������Lٴ>+s��S����H��ߓ��tn�_�hc�/���/uN�$�B*ZKǽ�T%ĳ����p�f��G�C�Į�1����iY[�[MO��u�I8?�f:0��U�|�.�&�}�>ney���[����f5���G^��%�F�?��dU��B��n��5�B���6^x\��W/�گӅۋ���4�ϳB��恿Ly_K���z��V�2[��֤�n�]n��~�F��!q��_�����?,�򿐁���� � o����g�/��o�o���#�;5����c�n1�|i�+u�C9�~S��r���
�����B>}��_���9�Kei�˙Q�]�K7���f˗�!�n���/��`���c¥2�)H��S�z����9Y��^�%W�2Y��u�a��?[|������g��~����ڛ_Z{��e�S����kkev��y�<�]�9NZ�H��Q�&���3����+�V������^'��~O;29�M����ݝH_��\Z[d�-�C���hH/���(g��z/�r���9g˜��lM����g����u�J.�d�(��+ѕ�S��X����򿐁����/Ā�����_��E�E*�<e$��XN�1D)gH:�HF"32�,&)��D����#���\�x���9p��W�_����2��X��LT�Q���
W���ƥ4�G�����i���_vxw��d�0��n���S[��^�M'b��M��]*\�Kk���v�|	�l.D���:8ۥ���JF�ȘjfIB������b���?�7�����×&����?���X� <�?�ߍЈ�ê.�4��?:�MQ��� �a��a�����{����ٔ��<��\ʄT�>IsNJ��KY��$1�؄�Ą�X����K�<&�4O���o��U�����F����iv�΅?�$��oČZ���L��ʣ[=�E��7�/���?x]��T����n�6�Q<�i��k�h	���$c]D��9��XS�;�!�J3D�_	�e��T�?<�VWgEU����]��/8<�)���C��W#���o� �����3���i,����WT4���+��������_�����Fh\�!�+�����f���F��o����o��F{���/���L�1߸��}�8�?����f�l?n���_����&��o����o��F���ߨh����o\����?��@G�� � �����?�����Ѯ�����x����z|S��xM��g�?��p��|��π�7AS��z����G����� �������Ͼ8���F�G�aeM�����q������������?�lF���]�a��,�������[��������A������������?,���C6���H������� �� ��!�������������[e��;d`���}�8�?C�������?I"��I��GGB.�b�q��E�D&L�D,��I�
d"g	G����Ȋ������{���3<�����&���O�ww;�2����{�\S��Ҭ�d=z�5����ػ�.5�l�ί�������y�&*��3���`���֪d��T%� ��I$�R�ɜ�Zk.#�}y�lGGC㓺�ƞ0M�G@5MM7R���qm�ϲ�I;������le��>�T�36;�H+e�z�'�5��g4c�U_%�c��-s�):�����J�ڸ�'���3����?�C[����W��}����z�� ��3t�� ��c ���9��������?]��?`��;��0������ ����?:��[����A�Gg�	���������?������?���@��������������z���/ � }��I��?�������|�����u-���K��lG�A�Y ���?� ����?��+{���Qs�,���i �|C��]0��+#/$	r�V�]J}4��қaʌw9�v61��vw��6m�Z��*v����ׯh�5�Q��)����)	׶�a��$U[]�y��̥����`dA.i�)��'-Ղ���k-�N�����a������z��@�Gg�X���������}�������A4��!�3���T��qL1X8z$�1��p��!:�<���؏�0&�� ��������w� ��W������ݳL�ny����gŊ�l�U�����;y�:9h�i�ꉇ	T��c�M<��P2�ݡ�����r�&C�����棃Q�~�X�1���TM}ךǳ�p�?ދ���_���=|����Ch���������_��(��V�������'1��m��#�{��ZA����"Pᐎ�'�hH�8���!�����1J0AD2C	#���ak�����+���Z����L^V�x�gGY�s*]f6�|ԛ�"�Z�c7�~L�6_�;<%gv��1����r6[��2�Ғ_Bs1Bu���j=��L6#ɃB]O���O��Y����I�-~Q���t��ދ>��Q�n�����6��s�m����E�����o+x��Kn�_����	7�K��MydpT�S'&Q������	��e��Ǿk�2�FL^�Ħ�����/�9�n��~���u���[�_k�[֖*7�Ҳ�|?�f/��%��κ	���N��mu�OЯ�����n�4֙�Q-V�Y�i$��1l�q�Fd��{������q�r|Յ��<_����A�l�[S؅�?�~�8I�*�M>�%l�5�Z2��e*�<b�)Y�*�lX|�����}�SH%9ә��4�P)�a��O�f��Y�ʇ�\m�Iq
K6�iTx�ؑ�z7��J�9L��3I5_�ɢ�.� �?B/؟��m�����&p��z�����?��6>� ䷿ ���k���ݡe�YN�z������?���M���V�����v��^��X��=�UNb��Vcev����z�3���?E#�_f�F_v~�;��+�G6ȲJ9O7OHuFe�G{n*D֜�ŏ�I��EuTcM˄�eWL5�¹��rN�ӭ��܅��}^�J×Y,s2.y�3*v�r�c.E�e��u���:Ƈ�XV��^�Ȥ�s���ɬ�I�C�z_.��f�QX�H���2�d��쩮��!��^�	_���A����1� ���t�q�`l�dS�ҵ�l|�<��|��Z�)K�U���ީ'��,]FSȊ�1�DX��n�t�?���[��C_��������6�� ䷿ ��c�>�?��ݡM�/	�M�O�����}�����#����7�?����!������ ����E4T�yich����6A�������{uލ��-���E���e��hn�yev�@�m����y��4��tl�����$�1�(��9��5?�� S
�T)�;�~����FxRӻ�I�
>n���G�-m3�P�Ϭ��Ҧ�%�f������ξD�Ȍ�q4�/G�@w�;��4��L������ ;*��_�͵��0��'WC��'�Q��3~NW��Qu��=/��t�*҈�S��cҊdS�����7��"����V�2���/����Y,(��%�Ꮖ^�?����S��_���{���&p����[�S�n��|'�Mk6I=��pK���	:�� �g���E}��`�g���E���JJ�z���T����P�d.텑�4�vl�V�9��j���2{ƈ�f'�f��P�*6l��VͫXVM^�{F���>U<����"�Z��}�̘0>�iEɤ��MiL�Ի��0antӾFqx�̵r�<%��0y�)g|R-!���O�=�B"��|`�52�#�ʝ&&q(,
	!�\Qr������-�?��3 �������_`�Ww��A���im�?P������A����U��[�7�a�w��co�Xrw5�@�"�Oր�׭ܐ��Weel���ԁ������[._� �06�\l}<lx̟���-S߸�]�[�K�h�9C�ɊG�����Z],�1��[^~|*�����Qcx�0�*:�����G�B��џ��:�]%�i,Χ���i�%�la5r�䎵.B�����U�̈3��G�h��9
��,!��|���If� �\8y������߭�+��_?��� ��&@�c+ �O �	�?}���^�?0��:���C�����?�������{�S�,�Σd�:
U��.g�� 6t뒠V����փ�X��#�=tw
KdV��z+s�"�/�Q��t�����ϝ���F���F�Tўǐ��*�[�����������k�����@��:�u��S4Qw�W����QBT��E��?Ηx�$��?qS�;�3)���Vw�Ǝg5�֧ ��l���; ߢ�����������J��S��������������P����A��;��������t���%��k���n_��g	���������@��o������B0��m���[� �=���]�?���4��6����p� �����?~����ZB�;D[��s��+���_+ �?P��?P���@�����N�~ �����z��؃�?P�k]�?0�����������?��`��6��	���������?��8��6�=��=�ZD/�?���c�����������٫�OV�v�n����#!��X����o�������Fb?g�q#Εн�s�^�}�k`�e�r�n����0-���T��9O���,���ƚ�	���j �s%���,�[{'��O��ؕ�/�X�d\�`�Ө�ŋ�7�� <oYz��I}�Ɖ�XV�/�f����dV֤ˏ�S��/��l3�(,V��Pog��f�T����f�kVu~"����Ҁ�1�����`*[�����gT��\�V6e��
#���;�$�t���h
Y�1#&����������G��o��y��
�[AW�/��U]"`����[�����G�����V�9�G11L�1C�NP��4s��tHR��Q�t� �ȫ5$��#�zx��՟������z��$��m������~>ɢ���K��~���IH���t=�S�6�%R_��#`(q��#D�SԅB�����̽�����fy�Ib�b*jm>N7���Es�A<�S鄠=E�Ɨ��P�2�`e�[���^�n�'͕�s8�r���s�}�uwO���g���%������?���/ eޞ����W����z��4u�� �������O�+ ���5�c��OP�i��?�����w���]�?��l	}���������DA����O��	�?A�g����A��t��@T� ��c�^�?�����z����w�^���O
� �O �	�?���n������VЩ�!P������z�����?���z��'m�������w�7���[������K�K�D�ᙳK'0�g�6���v��4җo��=[cl�����)��mvƟ_D��_^P����AOXW�'�4�b������dLI������"������f�ќ͵9T���)]I�q�`z���c����M�İӥ�RUb!y���e�X]`;�u%@���T�՗}%��r�5ׇ���/�4��Ց�/�?�x����g�������C�<�v��[�pA4\���*ΫmI�Ɣ&�DV�l����MY%3/3�T��р��1Ͷ�Xn�U`H\���r'������?;B���@u��?�������?0��
����q�yA�F11�b��$�$��T@��M�9D)l8���0�B��@ԯ���(���0��-�w�?!�.Ϧ4����"����C�sbOU�.��x,U��ك��O����ʹ�(�y�H�G��p���O�P�'�d2[��tr_�39!d�:�`0|��	.��ĩ��:��SW����?�����>%����V��?����4����������`?���W�!���SZ*v���P՟�á8���!�՟���ӕѷ�.��	UQ��_�=Y�#�U�ݓ�׷�{�
3�y�`���Θ�v�]^S��ry��K���]e���]�G#�D	A��@)�!#�eD�h���@ 1$��|�!��F

U�{~~[��IϢ��I��{Ͻu��Y�=���]m��%92�he<j�j5%��3@ٻ;�ߎ(j$�*l���/�W��U��>���w"ىܼq}5�
z�&/���2> ���Ն�{�]�8R�0ΝY�Q�~�m�ndW�ӗ���0R��ڰ���6�,E"2r"		�L[���}I>/�w4;2۶i��4
Z����#�獵�6u��(��p�H��x����E��
����I��N��/k����q"Ͽt����i�{jm0:b�#X���d�Zo�.�4%x����R�j��+W	��p�"y7��pp�s#("��\1_���ݘ6Rb�����{�P'�e}�q5m�s�|Q�?����9a��t�Gv�H����c#Y�WF��
��hУ��i�^����	e��+�����ҝ`�w��N�wJ�,��S�?�4���	ֈ�D�Nđ�F�� ^� ^�����>�ǟ���\Z��/�MAU]EQEKƕ��F�&�*���TBAR	='ᄢK���J\Nŕ��PRh&��@�dƅn|����~
-��惯��G��������o�/C��x��B�1���b=mC��S�X!�AO�}�_�SAK�@y��>��q�8(���9����r�u�P?�..�Ѓ�AW�.@`����A�S���pz�T^Z�u�&����
^���,�v��l�[?�����/�����ko����w����W�Ka�\������x�#�	t�w��l�3���x�<�`�G�$?"���]���w��v�ҋw��s��D��{o~"�����o��G_��ٿ��F��TK��@ �����m��v.��J�+.�4o�i��/�R	YW��(rBE��
�RZ����N&`UNəO��
��"�,��LBK"HVSr �7��_��W�+��g��������+ri�����=�#�}��| ,��M�G7O���	}�������'����{z�Y��=���Ň���0^K��k6�rI�������� �m)���
����yk����|v֞S�#��k8����:J���Bg_�K@a��(�We�����2����(�)�	�>�3t�yR�=Q�����ח�<e*��"՞��%5+�<���,w�z��6áGs�W8ؔ����N�8��7_6�D�����
D_�˪Q˻d�5|�_��ei�x�Z|F��f'ѡ����5��2>�G<L�A���<�f8�v%v`I<n��qw-��Hs����:n��5�l���o��y�#��]vh�M� ̲����`(����=�W3�>�^�F�r4��Ŕ)Y��{���}���x3)l�)��"�ڭ���(���м��p6[N=�%�����"��S�4�A�bL'^%4��|Ms`'Opg��'x����9���*\����R��Q�Qs�e�̒|���Ş�]�4��a�
���W,�_�0o.�0�a��%�'1`����<�%�Tb�"��t�<��Fu,^�f�jOY��Xe'6��0�v��:��\����o0^l�K�:��%Vz9 �	K���M ��Ek�LA`����-�8ޢr��|\ga�]���*�(�I;�Ub��?~���v���i��c(�(b�|4��%��R#��0�m����l��t-��K�CC�.WwYEw�Zr>Qt�_�-F������:�Xd*�	�ƃ2-�yf���E�.*Lf9#�n�SeH;`>K#��c��܀E�'�t]������,��T%E*Ӭٝ>�7�t'.�v*Omw���L?�`�#z��g�FM4�0���qv�v�Y� �=�Y
�$F������o��!9Y��db�q���I��g:�`��\o
��&�x	Ƈt5o�a�_o�~C�"�b�3Ut���1�Ϋ�״�[����zQ��
�.��Am�z�w�G4f`�B;~C�9���Gz�6o
֓��NXObc�̒�gش�ϰ	h�LO�cG�����q��s]�2��^^��&W����#Z���Q�I���$�!N�B7}%f�ө�0o�۳�M��ܜ t4�T���$%�cG�5��'�9&2�4�� ָT�f593���V�1��&���N�Yi%�������bEC��C��\=�U��V�t���rp����e���@v�q�H�<�z͍�&�Ĩ���yvj�&�)VF��=������_Or�.������Rt'~���5藂�uh�|��zb�r�xݛ�Z����-���5����W7�_��&�+e�߮�ɿu��W���W�@_�}��A��'����佚HJ|G��	n4��*���X����Y&�ǐ�o�w�,��cHg�����x0V֊��0c`/-�ۢL�k��Y�A��r0���^��tx��~}8w%~�/%�z�e�A�ϗh�1��Fq�wc��yQ��䨦�z��5߃���X# mk�禺WId���B0y����Mg�T8��y+�N_l�L��.�f���!�
�gW�F��,��͆�����0At)�cM��6��y?�,�1��?f�YFa��Z��t#�-%����؇����Cz���SS�hbc�"R��#$i���N�/W�m?1[�􁦓uj��'0B�1R�>?�,�9a���M��S�d�j/I��&���"��l)�^�YWeg�VV�s)��Ti��a6���X���䨖q[j�񪍢���<�t͑�&r�ld��ƋD��P@�hM�қ�����T�W��8��x-Yi�2^��;fb�G5���0��	&v;�%�^�EX�t��3�����hk,G�l�_E��19�ϣ�On��54��u{����V��[�7nA_�u��[U1��'6�OlN�8�_����K��>���%9k�|��C��,�@�4yD[c] ��V{���d�p�``�N<�>��j���1�Xi#��,ڈ�)�C%��;%��וƨ�o�����B7�b����`QLNl��D�{4�	!J��d ��Bv��c?��)����&{�'��g���M�D�i��Ϧ.׍֚F<W��I��E�6�ݖ�qT0o�t;��U��x`���Q�J��С%I$�,��Ú����"i��9�2�&���/�6q�M�c����sl�U�
�x�~ƼU���&zx������7�z��Ջ��_�8Օ�8�2ކ>�u�^�2^��^��7�����r����ʣ�+��{MV�FCSY�H����\	s5�{��ՠk�E������K�4R:�9נg��[����߁oܿY���o�5g<�~z
| A����tg�`׏d�������l�5�}r�8����y<������3�e��i��Hu\�pǴ�g8R�A�������Z�MJ#i�7��E�q@�����
=���LU���i�<�n��w���_a<����6��l`��6��l�g��v e � 