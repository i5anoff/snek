#!/usr/bin/sbcl --script

(load "../src/load")
(load "../utils/lorem")

(setf *print-pretty* t)
(setf *random-state* (make-random-state t))

(defvar *text* "lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.  nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?")


(defun main (size fn)
  (let ((left 55d0)
        (top 60d0)
        (bottom 950d0)
        (right 950d0)
        (grains 20)
        (nc 3)
        (ncn 2)
        (bbox (vec:vec 10d0 20d0))
        (spacebox (vec:vec 12d0 24d0))
        (sp 0.15d0)
        (sbox (vec:vec 1d0 3d0))
        (sand (sandpaint:make size
                :active (color:white 0.009)
                :bg (color:vdark))))

    (let ((alphabet (get-alphabet bbox nc ncn sp sbox))
          (snk (snek:make))
          (state-gen (math:get-state-gen (lambda () (rnd:get-acc-circ-stp*)))))
      (do-write snk alphabet spacebox top right bottom left *text*)
      (loop for i from 0 below 500 do
        (snek:with (snk)
          (snek:itr-all-verts (snk v)
            (snek:move-vert? v (rnd:in-circ 0.1d0))
            (snek:move-vert? v (funcall state-gen v 0.00001d0))))
        (snek:itr-grps (snk g)
          (aif (snek:get-grp-as-bzspl snk g)
               (sandpaint:pix sand (bzspl:rndpos it
                                     (* (rnd:rndi (- grains 5) (+ grains 5))
                                        (bzspl::bzspl-n it))))))))

    (sandpaint:pixel-hack sand)
    (sandpaint:save sand fn :gamma 1.5)))

(time (main 1000 (second (cmd-args))))
