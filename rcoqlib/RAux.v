(** R-CoqLib: general-purpose Coq libraries and tactics.
 
 Version 1.0 (2015-12-04)
 
 Copyright (C) 2015 Reservoir Labs Inc.
 All rights reserved.
 
 This file, which is part of R-CoqLib, is free software. You can
 redistribute it and/or modify it under the terms of the GNU General
 Public License as published by the Free Software Foundation, either
 version 3 of the License (GNU GPL v3), or (at your option) any later
 version.
 
 This file is distributed in the hope that it will be useful, but
 WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See LICENSE for
 more details about the use and redistribution of this file and the
 whole R-CoqLib library.
 
 This work is sponsored in part by DARPA MTO as part of the Power
 Efficiency Revolution for Embedded Computing Technologies (PERFECT)
 program (issued by DARPA/CMO under Contract No: HR0011-12-C-0123). The
 views and conclusions contained in this work are those of the authors
 and should not be interpreted as representing the official policies,
 either expressly or implied, of the DARPA or the
 U.S. Government. Distribution Statement "A" (Approved for Public
 Release, Distribution Unlimited.)
*)
(**
Author: Tahina Ramananandro <ramananandro@reservoir.com>

More properties about real numbers.
*)

Require Export Reals Psatz.
Require Export Omega.
Open Scope R_scope.

Lemma increasing_weaken f x y:
  (x < y -> f x < f y) ->
  x <= y -> f x <= f y.
Proof.
  intros.
  destruct (Req_dec x y); subst; lra.
Qed.

Lemma Rle_Rpower_strong:
  forall e n m : R, 1 < e -> n <= m -> Rpower e n <= Rpower e m.
Proof.
  unfold Rpower. intros.
  apply (increasing_weaken (fun t => exp (t * ln e))); auto.
  intros.
  apply exp_increasing.
  apply Rmult_lt_compat_r; auto.
  rewrite <- ln_1.
  apply ln_increasing; auto; lra.
Qed.

Lemma Int_part_unique x z:
  IZR z <= x ->
  IZR z - x > -1 ->
  z = Int_part x.
Proof.
  intros.
  destruct (base_Int_part x).
  assert (K: -1 < IZR z - IZR (Int_part x) < 1) by lra.
  replace (-1) with (IZR (-1)) in K by reflexivity.
  replace (1) with (IZR (1)) in K by reflexivity.
  rewrite <- minus_IZR in K.
  destruct K as [KL KR].
  apply lt_IZR in KL.
  apply lt_IZR in KR.
  omega.
Qed.

Lemma IZR_Int_part x y:
  IZR x <= y ->
  (x <= Int_part y)%Z.
Proof.
  intros.
  destruct (base_Int_part y).
  assert (K: -1 < IZR (Int_part y) - IZR x) by lra.
  rewrite <- minus_IZR in K.
  replace (-1) with (IZR (-1)) in K by reflexivity.
  apply lt_IZR in K.
  omega.
Qed.

Lemma powerRZ_Rpower a b:
  0 < a ->
  powerRZ a b = Rpower a (IZR b).
Proof.
  intros.
  destruct b; simpl.
  {
    rewrite Rpower_O; auto.
  }
  {
    rewrite Rpower_pow; auto.
  }
  rewrite Rpower_Ropp.
  rewrite Rpower_pow; auto.
Qed.

Lemma frac_part_sterbenz w:
  1 <= w ->
  IZR (Int_part w) / 2 <= w <= 2 * IZR (Int_part w).
Proof.
  intro K.
  generalize K.
  intro L.
  replace 1 with (IZR 1) in L by reflexivity.
  apply IZR_Int_part in L.
  apply IZR_le in L.
  simpl in L.
  destruct (base_Int_part w).
  lra.
Qed.


Lemma Rdiv_le_left d a b:
  0 < d ->
  a <= b * d ->
  a / d <= b.
Proof.
  intros.
  apply (Rmult_le_compat_r ( / d)) in H0.
  * rewrite Rmult_assoc in H0.
    rewrite <- Rinv_r_sym in H0; [ | lra].
    rewrite Rmult_1_r in H0.
    assumption.
  * cut (0 < / d); [ lra | ].
    apply Rinv_0_lt_compat.
    assumption.
Qed.

Lemma Rdiv_le_right_elim d a b:
  0 < d ->
  a <= b / d ->
  a * d <= b.
Proof.
  intros.
  apply Rdiv_le_left in H0.
  {
    unfold Rdiv in H0.
    rewrite Rinv_involutive in H0; lra.
  }
  apply Rinv_0_lt_compat.
  assumption.
Qed.

Lemma Rdiv_lt_right d a b:
  0 < d ->
  a * d < b -> a < b / d.
Proof.
  intros.
  apply (Rmult_lt_compat_r ( / d)) in H0.
  * rewrite Rmult_assoc in H0.
    rewrite <- Rinv_r_sym in H0; [ | lra].
    rewrite Rmult_1_r in H0.
    assumption.
  * apply Rinv_0_lt_compat.
    assumption.
Qed.

Lemma Rdiv_lt_left d a b:
  0 < d ->
  a < b * d ->
  a / d < b.
Proof.
  intros.
  apply (Rmult_lt_compat_r ( / d)) in H0.
  * rewrite Rmult_assoc in H0.
    rewrite <- Rinv_r_sym in H0; [ | lra].
    rewrite Rmult_1_r in H0.
    assumption.
  * apply Rinv_0_lt_compat.
    assumption.
Qed.

Lemma Rdiv_lt_left_elim d a b:
  0 < d ->
  a / d < b -> a < b * d.
Proof.
  intros.
  apply Rdiv_lt_right in H0.
  {
    unfold Rdiv in H0.
    rewrite Rinv_involutive in H0; lra.
  }
  apply Rinv_0_lt_compat.
  assumption.
Qed.

Lemma Rminus_diag x:
  x - x = 0.
Proof.
  ring.
Qed.

Lemma Rabs_triang1 a b u v:
  Rabs a <= u ->
  Rabs b <= v ->
  Rabs (a + b) <= u + v.
Proof.
  intros.
  eapply Rle_trans.
  {
    apply Rabs_triang.
  }
  lra.
Qed.

Lemma Rabs_triang2 a b c u v:
  Rabs (a - b) <= u ->
  Rabs (b - c) <= v ->
  Rabs (a - c) <= u + v.
Proof.
  intros.
  replace (a - c) with (a - b + (b - c)) by ring.
  apply Rabs_triang1; auto.
Qed.


Require Import ZArith.
Require Import List.

Ltac R_to_pos p :=
  match p with
  | 1%R => constr:(1%positive)
  | 2%R => constr:(2%positive)
  | 3%R => constr:(3%positive)
  | 1 + 2 * ?q =>
    let r := R_to_pos q in
    constr:(xI r)
  | 2 * ?q =>
    let r := R_to_pos q in
    constr:(xO r)
  end.

Ltac R_to_Z p :=
  match p with
  | - ?q =>
    let r := R_to_pos q in
    constr:(Z.neg r)
  | 0%R => constr:(0%Z)
  | ?q =>
    let r := R_to_pos q in
    constr:(Z.pos r)
  end.

(* Limits of derivatives and variations. *)

Theorem derivable_nonpos_decr :
  forall (f f':R -> R) (a b:R),
    a < b ->
    (forall c:R, a < c < b -> derivable_pt_lim f c (f' c)) ->
    (forall c:R, a < c < b -> f' c <= 0) ->
    forall x1 x2,
      a < x1 ->
      x1 <= x2 ->
      x2 < b ->
      f x2 <= f x1.
Proof.
  intros.
  destruct (Req_dec x1 x2).
  {
    apply Req_le.
    congruence.
  }  
  assert (K: x1 < x2) by lra.
  refine (let L := _ in (_ (MVT_cor2 f f' _ _ K L))).
  {
    intros.
    apply H0.
    lra.
  }
  destruct 1 as (c & ? & ?).
  cut (f' c * (x2 - x1) <= 0); [ lra | ].
  rewrite <- Ropp_0.
  rewrite <- (Ropp_involutive (f' c)).
  rewrite Ropp_mult_distr_l_reverse.
  apply Ropp_le_contravar.
  apply Rmult_le_pos.
  {
    refine (let M := _ in _ (H1 c M)).
    { lra. }
    lra.
  }
  lra.
Qed.

Theorem derivable_nonneg_incr :
  forall (f f':R -> R) (a b:R),
    a < b ->
    (forall c:R, a < c < b -> derivable_pt_lim f c (f' c)) ->
    (forall c:R, a < c < b -> 0 <= f' c) ->
    forall x1 x2,
      a < x1 ->
      x1 <= x2 ->
      x2 < b ->
      f x1 <= f x2.
Proof.
  intros.
  cut (opp_fct f x2 <= opp_fct f x1).
  {
    unfold opp_fct.
    lra.
  }    
  eapply derivable_nonpos_decr with (a := a) (b := b) (f' := opp_fct f'); eauto.
  {
    intros.
    apply derivable_pt_lim_opp.
    auto.
  }
  unfold opp_fct.
  intros.
  replace 0 with (- 0) by ring.
  apply Ropp_le_contravar.
  auto.
Qed.

Theorem derivable_nonneg_incr' :
  forall (f f':R -> R) (a b:R),
    (forall c:R, a <= c <= b -> derivable_pt_lim f c (f' c)) ->
    (forall c:R, a <= c <= b -> 0 <= f' c) ->
      a <= b ->
      f a <= f b.
Proof.
  intros.
  destruct (Req_dec a b).
  {
    subst. lra.
  }
  assert (K: a < b) by lra.
  refine (let L := _ in (_ (MVT_cor2 f f'  _ _ K L))).
  {
    assumption.
  }
  destruct 1 as (c & ? & ?).
  cut (0 <= f' c * (b - a)); [ lra | ].
  apply Rmult_le_pos.
  {
    apply H0.
    lra.
  }
  lra.
Qed.

Theorem derivable_nonpos_decr' :
  forall (f f':R -> R) (a b:R),
    (forall c:R, a <= c <= b -> derivable_pt_lim f c (f' c)) ->
    (forall c:R, a <= c <= b -> f' c <= 0) ->
      a <= b ->
      f b <= f a.
Proof.
  intros.
  cut (opp_fct f a <= opp_fct f b).
  {
    unfold opp_fct.
    lra.
  }
  apply derivable_nonneg_incr' with (opp_fct f').
  {
    intros.
    apply derivable_pt_lim_opp.
    auto.
  }
  {
    intros.
    generalize (H0 _ H2).
    unfold opp_fct.
    lra.
  }
  assumption.
Qed.

(* Absolute error for sine/cosine *)

Lemma sin_ub x: 0 <= x -> sin x <= x.
Proof.
  intros.
  pose (f t := sin t - t).
  cut (f x <= f 0).
  {
    unfold f.
    rewrite sin_0.
    lra.
  }
  apply derivable_nonpos_decr' with (f' := fun t => cos t - 1); auto; intros.
  {
    apply derivable_pt_lim_minus.
    {
      apply derivable_pt_lim_sin.
    }
    apply derivable_pt_lim_id.
  }
  generalize (COS_bound c).
  lra.
Qed.

Corollary sin_ub_abs_pos x:
  0 <= x ->
  Rabs x <= PI / 2 ->
  Rabs (sin x) <= Rabs x.
Proof.
  intro.
  rewrite (Rabs_right x) by lra.
  intro.
  rewrite Rabs_right.
  {
    apply sin_ub; auto.
  }
  apply Rle_ge.
  rewrite <- sin_0.
  generalize PI2_3_2; intro.
  apply sin_incr_1; try lra.   
Qed.

Corollary sin_ub_abs x:
  Rabs x <= PI / 2 ->
  Rabs (sin x) <= Rabs x.
Proof.
  intros.
  destruct (Rle_dec 0 x).
  {
    apply sin_ub_abs_pos; auto.
  }
  rewrite <- Rabs_Ropp.
  rewrite <- sin_neg.
  revert H.
  rewrite <- (Rabs_Ropp x).
  apply sin_ub_abs_pos.
  lra.
Qed.

Lemma sin_absolute_error_term x d:
  sin (x + d) - sin x = 2 * cos (x + d / 2) * sin (d / 2).
Proof.
  replace (x + d) with (x + d / 2 + d / 2) by field.
  replace x with (x + d / 2 - d / 2) at 2 by field.
  rewrite sin_plus.
  rewrite sin_minus.
  ring.
Qed.

Lemma sin_absolute_error_bound' x d:
  Rabs d <= PI ->
  Rabs (sin (x + d) - sin x) <= Rabs d.
Proof.
  intros.
  rewrite sin_absolute_error_term.
  rewrite Rabs_mult.
  rewrite Rabs_mult.
  rewrite Rabs_right by lra.
  replace (Rabs d) with (2 * 1 * Rabs (d / 2))
    by (unfold Rdiv; rewrite Rabs_mult;
        rewrite (Rabs_right ( / 2)) by lra;
        field).
  repeat rewrite Rmult_assoc.
  apply Rmult_le_compat_l.
  {
    lra.
  }
  apply Rmult_le_compat; auto using Rabs_pos.
  {
    apply Rabs_le.
    apply COS_bound.
  }
  apply sin_ub_abs.
  unfold Rdiv. rewrite Rabs_mult.
  rewrite (Rabs_right (/ 2)) by lra.
  lra.
Qed.

Lemma sin_absolute_error_bound x d:
  Rabs (sin (x + d) - sin x) <= Rmin (Rabs d) 2.
Proof.
  unfold Rmin.
  destruct (Rle_dec (Rabs d) 2).
  {
    apply sin_absolute_error_bound'.
    generalize (PI2_3_2). lra.
  }
  eapply Rle_trans.
  {
    apply Rabs_triang.
  }
  rewrite Rabs_Ropp.
  apply Rplus_le_compat;
    apply Rabs_le;
    apply SIN_bound.
Qed.

Lemma cos_absolute_error_bound x d:
  Rabs (cos (x + d) - cos x) <= Rmin (Rabs d) 2.
Proof.
  repeat rewrite cos_sin.
  rewrite <- Rplus_assoc.
  apply sin_absolute_error_bound.
Qed.

Lemma sin_abs_error a b d:
  Rabs (a - b) <= d ->
  Rabs (sin a - sin b) <= d.
Proof.
  intros.
  replace a with (b + (a - b)) by ring.
  eapply Rle_trans.
  {
    eapply sin_absolute_error_bound.
  }
  eapply Rle_trans.
  {
    apply Rmin_l.
  }
  assumption.
Qed.

Lemma cos_abs_error a b d:
  Rabs (a - b) <= d ->
  Rabs (cos a - cos b) <= d.
Proof.
  intros.
  replace a with (b + (a - b)) by ring.
  eapply Rle_trans.
  {
    eapply cos_absolute_error_bound.
  }
  eapply Rle_trans.
  {
    apply Rmin_l.
  }
  assumption.
Qed.

Lemma sin_abs x:
  Rabs x <= PI ->
  sin (Rabs x) = Rabs (sin x).
Proof.
  intros H.
  destruct (Rle_dec 0 x).
  {
    rewrite Rabs_right in * |- * by lra.
    rewrite Rabs_right; auto.
    generalize (sin_ge_0 x).
    lra.
  }
  destruct (Req_dec x (-PI)).
  {
    subst.
    rewrite sin_neg. 
    repeat rewrite Rabs_Ropp.
    rewrite Rabs_right by lra.
    rewrite sin_PI.
    rewrite Rabs_R0.
    reflexivity.
  }
  rewrite Rabs_left in * |- * by lra.
  rewrite sin_neg.
  rewrite Rabs_left; auto.
  apply sin_lt_0_var; lra.
Qed.

Lemma cos_abs_eq u:
  cos (Rabs u) = cos u.
Proof.
  destruct (Rle_dec 0 u).
  {
    rewrite Rabs_right by lra.
    reflexivity.
  }
  rewrite Rabs_left by lra.
  apply cos_neg.
Qed.

Lemma abs_sign (b: bool):
  Rabs (if b then -1 else 1) = 1.
Proof.
  destruct b.
  {
    rewrite Rabs_Ropp.
    apply Rabs_R1.
  }
  apply Rabs_R1.
Qed.

(* Square root *)

Lemma sqrt_pos_strict x:
  0 < x ->
  0 < sqrt x.
Proof.
  intros.
  assert (sqrt x <> 0).
  {
    intro ABSURD.
    apply sqrt_eq_0 in ABSURD; lra.
  }
  generalize (sqrt_pos x).
  lra.
Qed.

Lemma cos_sin_plus_bound a:
  Rabs (cos a + sin a) <= sqrt 2.
Proof.
  rewrite <- cos_shift.
  rewrite form1.
  match goal with
  |- Rabs (2 * cos ?u * cos ?v) <= _ =>
      replace v with (PI / 4) by field;
      rewrite cos_PI4
  end.
  assert (0 < sqrt 2) as HSQRT.
  {
    apply sqrt_pos_strict.
    lra.
  }
  rewrite Rabs_mult.
  eapply Rle_trans.
  {
    apply Rmult_le_compat; auto using Rabs_pos.
    {
      rewrite Rabs_mult.
      apply Rmult_le_compat; auto using Rabs_pos.
      {
        rewrite Rabs_right by lra.
        apply Rle_refl.
      }
      apply Rabs_le.
      apply COS_bound.
    }
    rewrite Rabs_right.
    {
      apply Rle_refl.
    }
    apply Rinv_0_lt_compat in HSQRT.
    lra.
  }
  eapply (eq_rect_r (fun t => t <= _)).
  {
    apply Rle_refl.
  }
  rewrite <- (sqrt_sqrt 2) at 1 by lra.
  field.
  lra.
Qed.

Lemma cos_sin_minus_bound a:
  Rabs (cos a - sin a) <= sqrt 2.
Proof.
  rewrite <- cos_neg.
  unfold Rminus.
  rewrite <- sin_neg.
  apply cos_sin_plus_bound.
Qed.

Lemma abs_cos_sin_plus_1 a:
  0 <= a <= PI / 2 ->
  Rabs (cos a) + Rabs (sin a) = cos a + sin a.
Proof.
  intros.
  generalize (cos_ge_0 a $( lra )$ $( lra )$ ).
  generalize (sin_ge_0 a $( lra )$ $( lra )$ ).
  intros.
  repeat rewrite Rabs_right by lra.
  reflexivity.
Qed.

Lemma abs_cos_sin_plus_aux_2 a:
  0 <= a <= PI ->
  exists b,
    Rabs (cos a) + Rabs (sin a) = cos b + sin b.
Proof.
  intros.
  destruct (Rle_dec a (PI / 2)).
  {
    exists a.
    apply abs_cos_sin_plus_1.
    lra.
  }
  exists (PI - a).
  replace a with ((- (PI - a)) + PI) at 1 by ring.
  rewrite neg_cos.
  rewrite cos_neg.
  rewrite Rabs_Ropp.
  replace a with (PI - (PI - a)) at 2 by ring.
  rewrite sin_PI_x.
  apply abs_cos_sin_plus_1.
  lra.
Qed.

Lemma abs_cos_sin_plus_aux_3 a:
  - PI <= a <= PI ->
  exists b,
    Rabs (cos a) + Rabs (sin a) = cos b + sin b.
Proof.
  intros.
  destruct (Rle_dec 0 a).
  {
    apply abs_cos_sin_plus_aux_2.
    lra.
  }
  replace a with (- (- a)) by ring.
  rewrite cos_neg.
  rewrite sin_neg.
  rewrite Rabs_Ropp.
  apply abs_cos_sin_plus_aux_2.
  lra.
Qed.

Lemma cos_period_1 x k:
  (0 <= k)%Z ->
  cos (x + 2 * IZR k * PI) = cos x.
Proof.
  intro LE.
  apply IZN in LE.
  destruct LE.
  subst.
  rewrite <- INR_IZR_INZ.
  apply cos_period.
Qed.

Lemma cos_period' k x:
  cos (x + 2 * IZR k * PI) = cos x.
Proof.
  destruct (Z_le_dec 0 k) as [ LE | ].
  {
    apply cos_period_1.
    omega.
  }
  match goal with
  |- cos ?a = _ =>
     rewrite <- (Ropp_involutive a);
     rewrite cos_neg;
     replace (- a) with ((- x) + 2 * (- IZR k) * PI) by ring
  end.
  rewrite <- opp_IZR.
  rewrite cos_period_1 by omega.
  apply cos_neg.
Qed.

Lemma sin_period' k x:
  sin (x + 2 * IZR k * PI) = sin x.
Proof.
  repeat rewrite <- cos_shift.
  match goal with
  |- cos ?a = _ =>
    replace a with (PI / 2 - x + 2 * (- IZR k) * PI) by ring
  end.
  rewrite <- opp_IZR.
  apply cos_period'.
Qed.

Lemma frac_part_ex x:
{ i |
  IZR (Int_part x) = x - i /\ 0 <= i < 1
}.
Proof.
  exists (x - IZR (Int_part x)).
  split.
  {
    ring.
  }
  generalize (base_Int_part x).
  lra.
Qed.

Lemma sin_period_minus x z:
  sin (x - IZR z * (2 * PI)) = sin x.
Proof.
  unfold Rminus.
  rewrite <- Ropp_mult_distr_l_reverse.
  rewrite <- opp_IZR.
  generalize (- z)%Z.
  clear z.
  intro z.
  replace (IZR z * (2 * PI)) with (2 * IZR z * PI) by ring.
  destruct z; simpl.
  {
    f_equal.
    ring.
  }
  {
    apply sin_period.
  }
  generalize (Pos.to_nat p).
  clear p.
  intro n.
  rewrite <- (sin_period _ n).
  f_equal.
  ring.
Qed.

Lemma cos_period_minus x z:
  cos (x - IZR z * (2 * PI)) = cos x.
Proof.
  repeat rewrite <- sin_shift.
  replace (PI / 2 - (x - IZR z * (2 * PI))) with (PI / 2 - x - IZR (- z) * (2 * PI)).
  {
    apply sin_period_minus.
  }
  rewrite opp_IZR.
  ring.
Qed.

Lemma cos_PI_x x:
  cos (PI - x) = - cos x.
Proof.
  replace (PI - x) with ((-x) + PI) by ring.
  rewrite neg_cos.
  rewrite cos_neg.
  reflexivity.
Qed.

Lemma abs_cos_sin_plus a:
  exists b,
    Rabs (cos a) + Rabs (sin a) = cos b + sin b.
Proof.
  remember (a / (2 * PI) + / 2) as u.
  remember (- Int_part u)%Z as k.
  rewrite <- (cos_period' k).
  rewrite <- (sin_period' k).
  apply abs_cos_sin_plus_aux_3.
  subst k.
  rewrite opp_IZR.
  destruct (base_Int_part u).
  remember (IZR (Int_part u)) as k.
  clear Heqk.
  subst.
  assert (k - / 2 <= a / (2 * PI)) as LE by lra.
  assert (a / (2 * PI) < k + 1 - / 2) as LT by lra.
  generalize (PI_RGT_0).
  intros.
  apply Rdiv_le_right_elim in LE; [ | lra ] .
  match type of LE with ?v <= _ =>
  replace v with (- (2 * - k * PI) - PI) in LE by field
  end.
  apply Rdiv_lt_left_elim in LT; [ | lra ] .
  match type of LT with _ < ?v =>
  replace v with (- (2 * - k * PI) + PI) in LT by field
  end.
  lra.
Qed.

Corollary abs_cos_sin_plus_le a:
  Rabs (cos a) + Rabs (sin a) <= sqrt 2.
Proof.
  match goal with
  |- ?u <= _ => rewrite <- (Rabs_right u)
  end.
  {
    destruct (abs_cos_sin_plus a) as (? & K).
    rewrite K.
    apply cos_sin_plus_bound.
  }
  generalize (Rabs_pos (cos a)).
  generalize (Rabs_pos (sin a)).
  lra.
Qed.

Lemma sqrt_abs_error x d:
  0 <= x ->
  0 <= x + d ->
  sqrt (x + d) - sqrt x = d / (sqrt (x + d) + sqrt x).
Proof.
  intros.
  destruct (Req_dec d 0).
  {
    subst.
    unfold Rdiv.
    rewrite Rplus_0_r.
    ring.
  }
  assert (0 < x \/ 0 < x + d) as OR by lra.
  assert (0 + 0 < sqrt (x + d) + sqrt x).
  {
    destruct OR.
    {
      apply Rplus_le_lt_compat.
      {
        apply sqrt_pos.
      }
      apply sqrt_pos_strict.
      assumption.
    }
    apply Rplus_lt_le_compat.
    {
      apply sqrt_pos_strict.
      assumption.
    }
    apply sqrt_pos.
  }
  replace d with (x + d - x) at 2 by ring.
  rewrite <- (sqrt_sqrt (x + d)) at 2 by assumption.
  rewrite <- (sqrt_sqrt x) at 5 by assumption.
  field.
  lra.
Qed.

Lemma sqrt_abs_error' x y:
  0 <= x ->
  0 <= y ->
  Rabs (sqrt y - sqrt x) = Rabs (y - x) / (sqrt y + sqrt x).
Proof.
  intros.
  replace y with (x + (y - x)) at 1 by ring.
  rewrite sqrt_abs_error by lra.
  unfold Rdiv.
  rewrite Rabs_mult.
  replace (x + (y - x)) with y by ring.
  destruct (Req_dec y x).
  {
    subst.
    rewrite Rminus_diag.
    rewrite Rabs_R0.
    ring.
  }
  f_equal.
  assert (0 < x \/ 0 < y) as OR by lra.
  generalize match OR with
  | or_introl K => or_introl (sqrt_pos_strict _ K)
  | or_intror K => or_intror (sqrt_pos_strict _ K)
  end.
  intros.
  generalize (sqrt_pos x). generalize (sqrt_pos y). intros.
  rewrite Rabs_Rinv by lra.
  f_equal.
  rewrite Rabs_right by lra.
  reflexivity.
Qed.

Corollary sqrt_abs_error_bound x y d:
  Rabs (y - x) <= d ->
  0 < x (* one of the two must be positive, we arbitrarily choose x *) ->
  0 <= y ->
  Rabs (sqrt y - sqrt x) <= d / (sqrt y + sqrt x).
Proof.
  intros Hxy Hx Hy.
  generalize (sqrt_pos y). intro.
  generalize (sqrt_pos_strict _ Hx). intro.
  rewrite sqrt_abs_error' by lra.
  apply Rmult_le_compat_r.
  {
    apply Rlt_le.
    apply Rinv_0_lt_compat.
    lra.
  }
  assumption.
Qed.

Lemma eq_le_le x y:
  x = y ->
  y <= x <= y.
Proof.
  lra.
Qed.
