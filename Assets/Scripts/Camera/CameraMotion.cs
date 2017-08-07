//=============================================================================
/// Author : Peng Jiawei
/// FileName : CameraMotion.cs
//=============================================================================
using UnityEngine;
using System.Collections;

namespace CameraMotion
{
	public class CameraMotion : MonoBehaviour
	{
		/// <summary>
		/// 动画类型:
		/// 0:无动画
		/// 1：等速水平移动
		/// </summary>
		[Range(0, 1), Header("动画类型---0：无动画，1：基本的等速移动(水平)")]
		public int MotionType = 1;

		[Header("移动速度")]
		public float MoveSpeed = 10f;

		public Vector3 StartPos = Vector3.zero;
		public Vector3 EndPos = Vector3.zero;
		public Vector3 LookAtPos = Vector3.zero;

		private Vector3 m_CurrentEndPos = Vector3.zero;

		private void Start()
		{
			transform.position = StartPos;
			m_CurrentEndPos = EndPos;
		}

		private void Update()
		{
			switch (MotionType)
			{
				case 1:
					transform.position = Vector3.Slerp(transform.position, m_CurrentEndPos, Time.deltaTime * MoveSpeed);
					transform.LookAt(LookAtPos);
					if (Vector3.Distance(transform.position, m_CurrentEndPos) < 0.001)
					{
						m_CurrentEndPos = Vector3.Distance(m_CurrentEndPos, EndPos) < Vector3.Distance(m_CurrentEndPos, StartPos) ? StartPos : EndPos;
					}
					break;
				default:
					break;
			}
		}
	}
}

// EOF